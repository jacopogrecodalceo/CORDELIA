import dearpygui.dearpygui as dpg
import numpy as np

PLOT_COLOR = (255, 229, 0)
WIDTH = 800
PLOT_HEIGHT = 300
PLOT_SPACING = 5
WINDOW_PADDING = 35

def smooth(data, window=5):
    return np.convolve(data, np.ones(window) / window, mode='same')

class WaveformViewer:
    def __init__(self, n_channels, sample_rate, waveform_history, ring_buffer, lock):
        self.n_channels = n_channels
        self.sample_rate = sample_rate
        self.waveform_history = waveform_history
        self.ring_buffer = ring_buffer
        self.lock = lock
        self.channel_tags = []

        self.height = (
            n_channels * PLOT_HEIGHT + (n_channels - 1) * PLOT_SPACING + WINDOW_PADDING
        )
        self._setup_gui()

    def _setup_gui(self):
        dpg.create_context()

        with dpg.theme() as global_theme:
            with dpg.theme_component(dpg.mvAll):
                dpg.add_theme_style(dpg.mvStyleVar_FrameRounding, 5, category=dpg.mvThemeCat_Core)
                dpg.add_theme_color(dpg.mvPlotCol_Line, PLOT_COLOR, category=dpg.mvThemeCat_Plots)
        dpg.bind_theme(global_theme)

        with dpg.window(
            label="Multi-Channel Waveform Viewer",
            width=WIDTH, height=self.height,
            no_close=True, no_collapse=True, no_move=True,
        ):
            for ch in range(self.n_channels):
                with dpg.plot(label=f"Channel {ch + 1}", height=PLOT_HEIGHT, width=-1):
                    dpg.add_plot_axis(dpg.mvXAxis, label=f"Time {self.waveform_history / self.sample_rate}s // {self.waveform_history} samps")
                    y_axis = dpg.add_plot_axis(dpg.mvYAxis, label="Amplitude")
                    dpg.set_axis_limits(y_axis, -1.0, 1.0)
                    tag = f"channel_{ch}_series"
                    dpg.add_line_series([], [], parent=y_axis, tag=tag, label=f"Ch {ch + 1}")
                    self.channel_tags.append(tag)

        dpg.create_viewport(
            title='Real-Time Csound Multi-Channel Viewer',
            width=WIDTH,
            height=self.height,
        )
        dpg.setup_dearpygui()
        dpg.show_viewport()

        with dpg.handler_registry():
            dpg.add_key_press_handler(key=dpg.mvKey_Escape, callback=self.exit_app)

    def update_waveform(self):
        with self.lock:
            stride = 5
            window = 5
            for ch in range(self.n_channels):
                raw = self.ring_buffer[:, ch]
                smoothed = smooth(raw, window=window)
                ys = smoothed[::stride].tolist()
                xs = list(range(0, self.waveform_history, stride))[:len(ys)]
                dpg.set_value(self.channel_tags[ch], [xs, ys])

    def timer_callback(self):
        self.update_waveform()
        dpg.set_frame_callback(dpg.get_frame_count() + 1, self.timer_callback)

    def run(self):
        self.timer_callback()
        dpg.start_dearpygui()
        dpg.destroy_context()

    def exit_app(self):
        dpg.stop_dearpygui()
import matplotlib.pyplot as plt
from matplotlib.widgets import Slider

def plot_adsr(attack, decay, sustain, release):
	t_attack = 0.1 * attack
	t_decay = 0.1 * decay
	t_release = 0.1 * release
	
	x = [0, t_attack, t_attack + t_decay, t_attack + t_decay + sustain, t_attack + t_decay + sustain + t_release]
	y = [0, 1, sustain, sustain, 0]
	
	plt.plot(x, y)
	plt.xlabel('Time')
	plt.ylabel('Amplitude')
	plt.title('ADSR Envelope')
	plt.ylim(0, 1.15)
	plt.xlim(0, t_attack + t_decay + sustain + t_release)
	plt.grid(True)
	plt.show()

def update_adsr(val):
	attack = attack_slider.val
	decay = decay_slider.val
	sustain = sustain_slider.val
	release = release_slider.val
	
	plot_adsr(attack, decay, sustain, release)

# Initialize sliders
fig, ax = plt.subplots()
plt.subplots_adjust(bottom=0.3)

attack_slider_ax = plt.axes([0.2, 0.15, 0.6, 0.03])
decay_slider_ax = plt.axes([0.2, 0.1, 0.6, 0.03])
sustain_slider_ax = plt.axes([0.2, 0.05, 0.6, 0.03])
release_slider_ax = plt.axes([0.2, 0.0, 0.6, 0.03])

attack_slider = Slider(attack_slider_ax, 'Attack', 0, 10, valinit=5)
decay_slider = Slider(decay_slider_ax, 'Decay', 0, 10, valinit=3)
sustain_slider = Slider(sustain_slider_ax, 'Sustain', 0, 1, valinit=0.7)
release_slider = Slider(release_slider_ax, 'Release', 0, 10, valinit=4)

sliders = [attack_slider, decay_slider, sustain_slider, release_slider]

for slider in sliders:
	slider.on_changed(update_adsr)

# Initialize plot
plot_adsr(attack_slider.val, decay_slider.val, sustain_slider.val, release_slider.val)

plt.show()

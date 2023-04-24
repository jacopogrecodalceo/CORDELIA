import matplotlib.pyplot as plt
import numpy as np
from matplotlib.widgets import Slider

# Enable interactive mode
plt.ion()

# Generate some x values
x = np.linspace(0, 1, 1024)

# Define a function for the curve
a0 = .5
scale = 1
y = scale * np.sqrt(np.maximum(x/a0-x, 0))

# Create a plot
fig, ax = plt.subplots()
l, = ax.plot(x, y)

# Add a slider to control the value of a
ax_a = plt.axes([0.2, 0.1, 0.6, 0.03], facecolor='lightgoldenrodyellow')
slider_a = Slider(ax_a, 'a', 0.0, 1.0, valinit=a0)

ax_b = plt.axes([0.4, 0.2, 0.7, 0.03], facecolor='lightgoldenrodyellow')
slider_b = Slider(ax_b, 'b', 0.0, 5.0, valinit=scale)

# Define a function to update the curve when the slider is moved
def update(val):
    a = slider_a.val
    b = slider_b.val
    y = b*np.sqrt(np.maximum(x/a-x, 0))
    l.set_ydata(y)
    fig.canvas.draw_idle()

slider_a.on_changed(update)
slider_b.on_changed(update)

# Show the plot
plt.show(block=True)

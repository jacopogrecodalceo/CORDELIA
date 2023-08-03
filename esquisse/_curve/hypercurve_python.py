import numpy as np
import matplotlib.pyplot as plt
from matplotlib.widgets import Slider

def gen_brachis():
	t = np.linspace(0, np.pi, 8192)
	a = 0.5
	
	def brachis(t, a):
		x = a * (t - np.sin(t))
		y = a * (1 - np.cos(t))
		return x, y
		
	return brachis(t, a)

def gen_exp():
    t = np.linspace(0, np.pi, 8192)
    a = 3
    
    def exp(t, a):
        x = a * (np.exp(t) - np.cos(t))
        y = a * (np.exp(t) - np.sin(t))
        return x, y
    
    return exp(t, a)

ind = 0

def next(event):
    global ind
    ind += 1
    i = ind % len(freqs)

    ydata = np.sin(2*np.pi*freqs[i]*x)
    l.set_ydata(ydata)
    plt.draw()
    

def prev(event):
    global ind
    ind -= 1
    i = ind % len(freqs)

    ydata = np.sin(2*np.pi*freqs[i]*x)
    l.set_ydata(ydata)
    plt.draw()

def rotate_curve(x, y, angle):
	# Convert angle to radians
	angle_rad = np.deg2rad(angle)
	
	# Perform rotation transformation
	x_rotated = x * np.cos(angle_rad) - y * np.sin(angle_rad)
	y_rotated = x * np.sin(angle_rad) + y * np.cos(angle_rad)
	
	return x_rotated, y_rotated

def normalize_curve(x, y):
	# Rescale y values between 0 and 1
	y_normalized = (y - np.min(y)) / (np.max(y) - np.min(y))
	
	# Rescale x values between 0 and 8192
	x_normalized = (x - np.min(x)) / (np.max(x) - np.min(x)) * 8192
	
	return x_normalized, y_normalized

def find_direction_change_points(x, y):
	# Calculate the derivative of the curve
	dx = np.gradient(x)
	dy = np.gradient(y)
	
	# Find the locations where the derivative changes sign
	sign_changes_x = np.where(np.diff(np.sign(dx)) != 0)[0]
	sign_changes_y = np.where(np.diff(np.sign(dy)) != 0)[0]
	
	return sign_changes_x, sign_changes_y


def draw_segment(angle):
	x, y = gen_exp()

	# Rotate the curve by the specified angle
	x, y = rotate_curve(x, y, angle)

	sign_changes_x, sign_changes_y = find_direction_change_points(x, y)

	# Check if change points exist
	if len(sign_changes_x) > 0:
		# Get the first change point index
		first_change_point_index_x = sign_changes_x[0]

		# Cut the arrays starting from the change point index
		x = x[first_change_point_index_x:]

	if len(sign_changes_y) > 0:
		# Get the first change point index
		first_change_point_index_y = sign_changes_y[0]

		# Cut the arrays starting from the change point index
		y = y[first_change_point_index_y:]

	# Find the minimum length between the cut arrays
	min_length = min(len(x), len(y))

	# Trim the arrays to have the same length
	x = x[:min_length]
	y = y[:min_length]

	x, y = normalize_curve(x, y)
	return x, y

def show_segment():
	angle = 0
	x, y = draw_segment(angle)

	fig, ax = plt.subplots()
	plt.subplots_adjust(bottom=0.25)

	# Plot the curve
	line, = ax.plot(x, y)
	ax.set_xlabel('x')
	ax.set_ylabel('y')
	ax.set_title(f'{angle}°')
	ax.grid(True)

	# Create the fader slider
	ax_fader = plt.axes([0.2, 0.1, 0.6, 0.03])
	fader = Slider(ax_fader, 'Fader', 0, 360, valinit=angle)

	def update(val):
		# Update the angle value based on the fader position
		new_angle = fader.val

		# Rotate the curve by the updated angle
		new_x, new_y = draw_segment(new_angle)

		# Update the curve data
		line.set_xdata(new_x)
		line.set_ydata(new_y)

		# Update the plot title
		ax.set_title(f'Rotated {new_angle}° Brachistochrone Curve')

		# Redraw the plot
		fig.canvas.draw_idle()

	# Register the update function with the fader slider
	fader.on_changed(update)

	# Show the plot
	plt.show()

show_segment()
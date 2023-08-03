import numpy as np
import matplotlib.pyplot as plt
import ipywidgets as widgets
from IPython.display import display

def gen_brachis():
	t = np.linspace(0, np.pi, 8192)
	a = 0.5
	
	def brachis(t, a):
		x = a * (t - np.sin(t))
		y = a * (1 - np.cos(t))
		return x, y
		
	return brachis(t, a)

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


import matplotlib.pyplot as plt
import pyqtgraph as pg
from pyqtgraph.Qt import QtCore, QtGui

def show_segment(angle):
    plt.clf()  # Clear the plot

    x, y = gen_brachis()

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

    plt.plot(x, y)
    plt.xlabel('x')
    plt.ylabel('y')
    plt.title(f'Rotated {angle}° Brachistochrone Curve')
    plt.grid(True)
    plt.show()

# Create a Qt application
app = QtGui.QGuiApplication([])

# Create a main window
win = pg.GraphicsLayoutWidget()
win.setWindowTitle('Live Control')

# Create a slider control
slider = pg.QtGui.QSlider(QtCore.Qt.Horizontal)
slider.setRange(0, 180)
slider.setValue(89)
slider.setTickInterval(1)
slider.setTickPosition(pg.QtGui.QSlider.TicksBelow)

# Create a label for the slider
label = pg.QtGui.QLabel("Angle")
label.setAlignment(QtCore.Qt.AlignCenter)

# Create a layout and add the slider and label to it
layout = pg.QtGui.QGridLayout()
layout.addWidget(label, 0, 0)
layout.addWidget(slider, 1, 0)

# Create a widget and set the layout
widget = pg.QtGui.QWidget()
widget.setLayout(layout)

# Add the widget to the main window
win.addItem(widget)

# Define the function to update the plot when the slider value changes
def update_angle():
    angle = slider.value()
    show_segment(angle)

# Connect the slider's valueChanged signal to the update_angle function
slider.valueChanged.connect(update_angle)

# Call the show_segment function initially
show_segment(slider.value())

# Start the Qt event loop
app.exec_()

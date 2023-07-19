import numpy as np
import matplotlib.pyplot as plt

# Generate some sample data
x1 = np.linspace(0, 1, 100)
y1 = np.sin(2*np.pi*x1)

x2 = np.linspace(1, 2, 100)
y2 = np.cos(2*np.pi*x2)

x3 = np.linspace(2, 3, 100)
y3 = np.tan(2*np.pi*x3)

# Concatenate the data
x = np.concatenate((x1, x2, x3))
y = np.concatenate((y1, y2, y3))

# Plot the concatenated curve
plt.plot(x, y)
plt.show()

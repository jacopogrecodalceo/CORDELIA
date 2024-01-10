from p5 import *

def setup():
	size(1920, 1080)  # Set the size of the canvas

def draw():
	background(0)   # Set the background color to black
	fill(255)       # Set the fill color to white

	# Draw multiple random elements
	for _ in range(10):
		draw_element()

def draw_element():

	x_position = int(random_uniform(0, width/2))
	y_position = int(random_uniform(0, height/2))

	strokeWeight(1);
	rect(width,height,0,0);

if __name__ == "__main__":
	run()

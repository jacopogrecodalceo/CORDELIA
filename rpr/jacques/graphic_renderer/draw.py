from matplotlib import colors

# DRAW UTILs
def points(b, points, color='purple', alpha=1):    
	b.fill(*colors.to_rgba(color, alpha=alpha))
	b.stroke(None)
	for (x, y) in points:
		# Draw a small circle at the point
		b.circle(x, y, 15)  # Point radius
		
def pitches(b, points, pitches, font_size=32, offset_x=0, offset_y=0, color='black', alpha=1):
	b.fill(*colors.to_rgba(color, alpha=alpha))
	b.stroke(None)
	b.fontsize(font_size)  # Adjust font size as needed
	for pitch, (x, y) in zip(pitches, points):
		b.text(f'{pitch}', x+offset_x, y+offset_y)  # Offset the text slightly from the point

def staff_name(b, points, name, font_size=32, color='black', alpha=1):
	b.fill(*colors.to_rgba(color, alpha=alpha))
	b.stroke(None)
	b.fontsize(font_size)  # Adjust font size as needed
	b.text(name, points[0], points[1])  # Offset the text slightly from the point

# DRAW LINEs
def linear(b, points, stroke_width=3, alpha=1, color='black'):
	b.strokewidth(stroke_width)
	b.stroke(*colors.to_rgba(color, alpha=alpha))
	b.fill(None)

	for i in range(len(points) - 1):  # Do not connect start/end
		b.line(points[i][0], points[i][1], points[i + 1][0], points[i + 1][1])
	#b.moveto(points[-1][0], points[-1][1])

def bezier(b, points, stroke_width=3, alpha=1, color='black'):
	b.strokewidth(stroke_width)
	b.stroke(*colors.to_rgba(color, alpha=alpha))
	b.fill(None)

	if len(points) < 3:
		return

	# Start drawing from the first point
	b.beginpath(points[0][0], points[0][1])

	# Draw Bézier curves for each point except the last one
	for i in range(1, len(points) - 1):  # Stop before the last point
		x0, y0 = points[i]
		x1, y1 = points[i + 1]
		# Control points for smooth transition
		ctrl1 = ((x0 + x1) / 2, y0)
		ctrl2 = ((x0 + x1) / 2, y1)
		b.curveto(ctrl1[0], ctrl1[1], ctrl2[0], ctrl2[1], x1, y1)
	b.moveto(points[-1][0], points[-1][1])

	# End the path
	b.endpath()

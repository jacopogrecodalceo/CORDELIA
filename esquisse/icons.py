import Cocoa
import os

from wand.image import Image
from wand.color import Color

icon_path = '/Users/j/Documents/PROJECTs/CORDELIA/_GEN/_books/boobie/bea.png'
file_path = '/Users/j/Documents/PROJECTs/CORDELIA/_GEN/_books/boobie/bea.orc'


temp_path = 'temp.png'
with Image(filename = icon_path) as img:

	background_color = Color('white')

	if img.width > img.height:
		img.border(background_color, 0, int((img.width-img.height)/2))
	elif img.height > img.width:
		img.border(background_color, img.height-img.width, 0)

	# Save the image as a new file
	img.save(filename=temp_path)

icon_image = Cocoa.NSImage.alloc().initWithContentsOfFile_(temp_path)
icon_data = icon_image.TIFFRepresentation()

workspace = Cocoa.NSWorkspace.sharedWorkspace()
file_url = Cocoa.NSURL.fileURLWithPath_(file_path)

workspace.setIcon_forFile_options_(icon_image, file_url.path(), 0)

os.remove(temp_path)

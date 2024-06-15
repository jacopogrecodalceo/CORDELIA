# Importing the os module for file operations
import os

def write_hello_to_file(file_path):
    # Open the file in write mode ('w')
    with open(file_path, 'w') as file:
        # Write the text 'hello' to the file
        file.write("hello22reaper")

# Specify the file path
file_path = "/Users/j/Documents/PROJECTs/CORDELIA/rpr/test/hello.txt"

# Call the function to write "hello" to the file
write_hello_to_file(file_path)

print(f"Content 'hello' has been written to {file_path}")

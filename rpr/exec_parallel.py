import subprocess
import concurrent.futures
import time

def time_execution(func):
    def wrapper(*args, **kwargs):
        start_time = time.time()
        func(*args, **kwargs)
        end_time = time.time()
        elapsed_time = end_time - start_time
        print(f"Function '{func.__name__}' took {elapsed_time:.6f} seconds to execute.")
        return
    return wrapper

def run_bash_command(command):
    try:
        result = subprocess.run(command, shell=True, capture_output=True, text=True, check=True)
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        return f"Error running command: {command}\n{e.stderr.strip()}"

@time_execution
def main_parallel():
    commands = [
        "atsa /Users/j/Desktop/w.wav /Users/j/Desktop/w1.ats",
        "atsa /Users/j/Desktop/w.wav /Users/j/Desktop/w2.ats",
        "atsa /Users/j/Desktop/w.wav /Users/j/Desktop/w3.ats",
        "atsa /Users/j/Desktop/w.wav /Users/j/Desktop/w4.ats",
    ]

    with concurrent.futures.ThreadPoolExecutor() as executor:
        # Using a list comprehension to start all commands concurrently.
        # This returns a list of futures.
        futures = [executor.submit(run_bash_command, command) for command in commands]

        # Wait for all the commands to finish and retrieve the results.
        results = [future.result() for future in concurrent.futures.as_completed(futures)]

    # Print the results
    for i, result in enumerate(results, start=1):
        print(f"Command {i} output: {result}")

@time_execution
def main_classic():
    commands = [
        "atsa /Users/j/Desktop/w.wav /Users/j/Desktop/w1.ats",
        "atsa /Users/j/Desktop/w.wav /Users/j/Desktop/w2.ats",
        "atsa /Users/j/Desktop/w.wav /Users/j/Desktop/w3.ats",
        "atsa /Users/j/Desktop/w.wav /Users/j/Desktop/w4.ats",
    ]

    for c in commands:
        subprocess.run(c, shell=True, capture_output=True, text=True, check=True)

if __name__ == "__main__":
	main_parallel()
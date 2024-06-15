import cProfile
import pstats
import yappi
from line_profiler import LineProfiler

def profile_it(func):
	"""
	Decorator (function wrapper) that profiles a single function
	@profileit()
	def func1(...)
			# do something
		pass
	"""
	def wrapper(*args, **kwargs):
		func_name = func.__name__ + ".pfl"
		prof = cProfile.Profile()
		retval = prof.runcall(func, *args, **kwargs)
		prof.dump_stats(func_name)
		prof = pstats.Stats(func_name)
		prof.strip_dirs().sort_stats('cumulative').print_stats()
		return retval

	return wrapper

def yappi_profile_it(func):
	def wrapper(*args, **kwargs):
		yappi.set_clock_type("cpu")  # Use "wall" for wall time
		yappi.start()
		result = func(*args, **kwargs)
		yappi.stop()

		print("Function Stats:")
		yappi.get_func_stats().print_all()

		print("\nThread Stats:")
		yappi.get_thread_stats().print_all()

		return result

	return wrapper


def line_profile_it(func):
	def profiled_func(*args, **kwargs):
		profiler = LineProfiler()
		profiler.add_function(func)
		profiler.enable_by_count()
		result = profiler(func)(*args, **kwargs)
		profiler.print_stats()
		return result
	return profiled_func


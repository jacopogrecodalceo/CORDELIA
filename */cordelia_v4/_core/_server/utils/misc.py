import time


def count_time(start_time):
    print('---%s seconds---' % (time.time() - start_time))

def county_time(start_time, label):
    print('--->>>>>>>>>>' + label + '  ---%s seconds---' % (time.time() - start_time))

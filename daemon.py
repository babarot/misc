#!/usr/bin/python

import os
import sys
import time

def daemonize():
    pid = os.fork()

    if pid > 0:
        f = open('/tmp/log/example.pid', 'w')
        f.write(str(pid) + "\n")
        f.close()
        sys.exit(0)

    if pid == 0:
        while True:
            print "hello"
            time.sleep(1)

if __name__ == '__main__':
    daemonize()

#!/usr/bin/env python
# -*- coding: utf-8 -*-


import sys
import termios
import tty


def yesno(message):
    result = ''
    sys.stdout.write(message)
    sys.stdout.flush()
    attribute = termios.tcgetattr(sys.stdin)
    tty.setcbreak(sys.stdin)
    try:
        while True:
            char = sys.stdin.read(1)
            if char == 'y' or char == 'Y':
                result = 'y'
                break
            elif char == 'n' or char == 'N':
                result = 'n'
                break
    except KeyboardInterrupt:
        result = '^C'
    termios.tcsetattr(sys.stdin, termios.TCSAFLUSH, attribute)
    print result
    return result


result = yesno('よろしいですか? (y/n) ')
if result == 'y':
    print '[Y]が押された'
elif result == 'n':
    print '[N]が押された'
elif result == '^C':
    print '[Ctrl]+[C]が押された'

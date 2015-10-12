#!/usr/bin/env python
# -*- coding:utf-8 -*-

import sys
import time
from random import random

def progress_bar(label, end_val, bar_length=40, slug='#', space=' '):
    def writing_bar(label, bar, percent):
        sys.stdout.write("\r{label}: [{bar}] {percent}%".format(
            label=label, bar=bar, percent=percent
        ))
        sys.stdout.flush()

    for i in range(0, end_val):
        percent = float(i) / end_val
        slugs = slug * int(round(percent * bar_length))
        spaces = space * (bar_length - len(slugs))
        # Some processing...
        # Is provisional
        time.sleep(random() * 0.1)
        writing_bar(label, slugs + spaces, int(round(percent * 100)))
    writing_bar(label, slugs + spaces, 100)
    sys.stdout.write('\n')

if __name__ == '__main__':
    progress_bar("Processing", 100)

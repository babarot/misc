#!/usr/bin/env python

import os
import sys

def fild_all_files(directory):
    for root, dirs, files in os.walk(directory):
        yield root
        for file in files:
            yield os.path.join(root, file)

def show_dropbox_files():
    file_lists = []
    ignore_lists = ['.git', '.dropbox', 'Camera Uploads', 'Public']
    dropbox_path = os.getenv('HOME') + '/Dropbox'

    for file in fild_all_files(dropbox_path):
        if filter(lambda x:x in file, ignore_lists):
            continue
        file_lists.append(file)

    return file_lists

if __name__ == "__main__":
    argvs = sys.argv
    argc = len(argvs)

    for file in show_dropbox_files():
        if argc > 1:
            if argvs[1] in file:
                print file
        else:
            print file

    sys.exit (None)


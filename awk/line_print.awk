#!/usr/local/bin/gawk
# line_print.awk:

BEGIN {
    writeCount = 1000;
    lineCount = 0;
}

{
    lineCount++;

    if (lineCount == writeCount) {
        print $0;

        lineCount = 0;
    }
}

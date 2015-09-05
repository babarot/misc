#! /usr/local/bin/gawk -f
# yearend.awk
# 来年まであと何日かを表示する
# usage: gawk -f yearend.awk

BEGIN {
    year = strftime("%Y");

    if ((year % 4) == 0 && (year % 100) != 0 || (year % 400) == 0) {
        year_days = 366;
        } else {
        year_days = 365;
    }

    print year_days - strftime("%j");
}

#!/bin/bash

version=7.4
#unstable=unstable/
unstable=
patch_url=http://ftp.vim.org/pub/vim/${unstable}patches/${version}

start=$(gawk '{l = gensub(/'${version//./\\.}'\.(.*)/, "\\1", "", $2)} END {print l+1}' README 2> /dev/null || echo 001)
wget --no-cache $patch_url/README -N
end=$(gawk '{l = gensub(/'${version//./\\.}'\.(.*)/, "\\1", "", $2)} END {print l}' README)
if [ $start -le $end ]; then
    echo "$start .. $end start."
    if [ -e MD5SUMS ]; then cp -p MD5SUMS MD5SUMS.old; fi
    wget --no-cache $patch_url/MD5SUMS -N
    for i in `seq -f %03g $start $end`; do echo $patch_url/$version.$i; done | xargs wget
    if [ -e MD5SUMS.old ]; then diff -u MD5SUMS.old MD5SUMS; fi
    echo "$start .. $end done."
fi

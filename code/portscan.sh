#!/bin/bash
# cf http://qiita.com/Fool_Yahooman/items/298b20a2a11ecea1391d

logfile=portscan.log
portlist="$1"

if [ $# -lt 1 ]; then
    echo "Usage: `basename $0` portlist"
    exit 0
fi

if [ ! -r ${portlist} ]; then
    echo "${portlist} can not read."
    exit 1
fi

echo `date +'%Y/%m/%d %H:%M:%S'` `basename $0` scanstart >> ${logfile}

while read line
do
    echo ${line} | grep -E -e '^[[:blank:]]*$' -e '^[[:blank:]]*#' >/dev/null
    if [ $? -eq 0 ]; then
        continue
    fi

    echo -e "`date +'%Y/%m/%d %H:%M:%S'`\c"

    dest=`echo ${line} | awk '{print $1,$2}'`
    (sleep 1; echo -e "\x1d"; sleep 1; echo quit) | telnet ${dest} >> ${logfile} 2>&1

    if [ $? -eq 0 ]; then
        echo " - `date +'%Y/%m/%d %H:%M:%S'` OK"
    else
        echo " - `date +'%Y/%m/%d %H:%M:%S'` NG"
    fi

done < ${portlist}

echo `date +'%Y/%m/%d %H:%M:%S'` `basename $0` scanend >> ${logfile}

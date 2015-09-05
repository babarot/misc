#! /usr/local/bin/gawk -f
# tabspc.awk
'{gsub(/\t/,"[TAB]");gsub(/ /,"[SPC]")}1'

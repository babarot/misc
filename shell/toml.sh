skip=0
cat ./etc/init/assets/go/config.toml \
    | while read line
    do
        if [[ $line =~ ^repo ]]; then
            skip=1
            continue
        fi
        [ $skip -eq 0 ] && continue
        [ "$line" = "]" ] && break
        echo $line
    done \
        | sed -e 's/^"//g;s/",$//g'

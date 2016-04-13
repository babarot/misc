cnt=0
for d in ~/.vim/bundle/*; do
    if [ -d $d/.git ]; then
        echo "Updating $d"
        cd $d && git pull --quiet &
        (( (cnt += 1) % 16 == 0 )) && wait
    fi
done
wait

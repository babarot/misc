for i in 1 2 3 4
do
    echo sleep $i
    sleep $i &
    if (( (count+=1) % 2 == 0 )); then
        wait
    fi
done
wait

any() {
    local p
    for p in "$@"
    do
        if kill -0 "$p" &>/dev/null; then
            return 0
        fi
    done
    return 1
}
wait() {
    while any "$@"
    do
        true
    done
}

for i in 1 2 3 4
do
    echo sleep $i
    sleep $i & pids+=($!)
done
wait "${pids[@]}"

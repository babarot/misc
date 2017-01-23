typeset -A all_progress
all_progress=(
1  0
2  0
3  0
4  0
)
printf "\n\n\n\n"

any() {
    local i
    for i in "$@"
    do
        if [[ $jobstates =~ $i ]]; then
            return 0
        fi
    done
    return 1
}

typeset -a ids

sleep 2 & ids+=($!)
sleep 3 & ids+=($!)
sleep 4 & ids+=($!)
sleep 2 & ids+=($!)

while any "$ids[@]"; do
    sleep 0.01
    index=$(( $RANDOM % 4 + 1)) # +1 is for zsh
    all_progress[$index]=$(( all_progress[$index] + 1))

    printf "\033[1000D"
    printf "\033[4A"

    for progress in "$all_progress[@]"
    do
        if ! any "$ids[@]"; then
            printf "Installed!             \n"
        else
            printf "Installing... $progress\n"
        fi
    done
done

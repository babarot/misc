autoload -Uz colors; colors
typeset    TMPFILE="/tmp/.spin-$$$RANDOM"

move() {
    col="$1"
    line="$2"
    printf "\r\033[${line};${col}f"
}

eraceCurrentLine() {
    printf "\033[2K\r"
}

get_line() {
    echo -ne "\r\033[6n"
    read -s -d\[ garbage
    read -s -d R foo
    REPLY=$(echo "$foo" | sed 's/;.*$//')
}

sp() {
    local    spinner
    local -a spinners
    spinners=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)

    sleep $2 & id=$!

    while [[ $jobstates =~ $id ]]
    do
        for spinner in "${spinners[@]}"
        do
            sleep 0.05
    printf "\033[1000D"
    printf "\033[3A"
            printf " $fg[white]$spinner$reset_color  Installing...  $1\n" 2>/dev/null
            [[ $jobstates =~ $id ]] || break
        done
    done

    printf " $fg_bold[blue]\U2714$reset_color  $fg[green]Installed!$reset_color     $1\n"
}

# hide cursor
tput civis

printf "\n\n\n"
{ sp zplug/zplug 1.5 } &
{ sp b4b4r07/enhancd 1.2 } &
{ sp b4b4r07/gomi 1.7 } &
wait

# show cursor
tput cnorm

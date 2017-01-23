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

    #line
    #line=$REPLY
    line=$1

    sleep ${3:-1} & id=$!

    while [[ $jobstates =~ $id ]]
    do
        for spinner in "${spinners[@]}"
        do
            sleep 0.05
            printf "\r\033[$line;1f $fg[white]$spinner$reset_color  Installing...  $2" 2>/dev/null
            [[ $jobstates =~ $id ]] || break
        done
    done

    move 1 $line
    eraceCurrentLine
    printf " $fg_bold[blue]\U2714$reset_color  $fg[green]Installed!$reset_color     $2\n"
}

# hide cursor
tput civis

get_line
line=$REPLY
printf "\n\n\n"
{ sp $(( line+=0 )) zplug/zplug 1.5 } &
{ sp $(( line+=1 )) b4b4r07/enhancd 1.2 } &
{ sp $(( line+=2 )) b4b4r07/gomi 1.7 } &
wait

# show cursor
tput cnorm

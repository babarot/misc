move() {
    col="$1"
    line="$2"
    printf "\033[${line};${col}f"
}

eraceCurrentLine() {
    printf "\033[2K\r"
}

line() {
    echo -ne "\r\033[6n"
    read -s -d\[ garbage
    read -s -d R foo
    REPLY=$(echo "$foo" | sed 's/;.*$//')
}

# {
#     line
#     line1="$REPLY"
#     printf "\rInstalling...\n"
# }
# 
# sleep 1
# 
# {
#     line
#     line2="$REPLY"
#     printf "\rInstalling...\n"
# }
# 
# sleep 1
# 
# {
#     move 1 $line1
#     eraceCurrentLine
#     printf "\rInstalled!\n"
# }
# 
# sleep 1
# 
# {
#     move 1 $line2
#     eraceCurrentLine
#     printf "\rInstalled!\n"
# }

typeset -A -gx cursor_table

repos=(
b4b4r07/enhancd
zplug/zplug
zplug/vim-zplug
)

rm -rf zplug vim-zplug enhancd
setopt nonotify nomonitor
autoload -Uz colors; colors
typeset -F SECONDS=0

for repo in "$repos[@]"
do
    line
    printf "\033[?25l\rInstalling... $repo\n"
    cursor_table[$repo]=$REPLY

    {
        git clone "https://github.com/$repo" &>/dev/null
        move 1 $cursor_table[$repo]
        eraceCurrentLine
        printf "\r$fg[green]Installed!$reset_color    $repo\n"
    } &
done
#wait %${(k)^jobstates[(R)running:*]}
wait
printf "\033[?25h\nElapsed time: ${SECONDS}s\n"

#curses
#tput("civis") // hide
#tput("cvvis") // show
#fmt.Print("\033[?25l")
#fmt.Print("\033[?25h")


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

typeset -A -gx cursor_table

repos=(
b4b4r07/enhancd
zplug/zplug
zplug/vim-zplug
zsh-users/zsh-completions
zsh-users/antigen
b4b4r07/emoji-cli
)

rm -rf ${repos[@]:t}
rm -rf ~/.run
mkdir -p ~/.run

setopt nonotify nomonitor
autoload -Uz colors; colors
typeset -F SECONDS=0
typeset -A main spin

for repo in "$repos[@]"
do
    line
    printf "\033[?25l\rInstalling... $repo\n"
    cursor_table[$repo]=$REPLY

    {
        sleep 0.5
        while [[ ! -f ~/.run/${repo:t} ]]; do
            [[ ! -f ~/.run/${repo:t} ]] && { printf "\r\033[$cursor_table[$repo];1fInstalling    $repo"; sleep .5 }
            [[ ! -f ~/.run/${repo:t} ]] && { printf "\r\033[$cursor_table[$repo];1fInstalling.   $repo"; sleep .5 }
            [[ ! -f ~/.run/${repo:t} ]] && { printf "\r\033[$cursor_table[$repo];1fInstalling..  $repo"; sleep .5 }
            [[ ! -f ~/.run/${repo:t} ]] && { printf "\r\033[$cursor_table[$repo];1fInstalling... $repo"; sleep .5 }
        done
    } &

    {
        git clone "https://github.com/$repo" &>/dev/null
        touch ~/.run/${repo:t}
        move 1 $cursor_table[$repo]
        eraceCurrentLine
        printf "\r$fg[green]Installed!$reset_color    $repo"
    } &
done
#wait %${(k)^jobstates[(R)running:*]}
wait
eraceCurrentLine
printf "\n\r\033[?25hElapsed time: ${SECONDS}s\n"


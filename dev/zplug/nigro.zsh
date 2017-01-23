#!/usr/bin/env zsh

eraceCurrentLine() {
    printf "\033[2K\r"
}

typeset -A pkgs ok
typeset -F SECONDS=0
spinners=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)

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

repos=(
b4b4r07/enhancd
b4b4r07/gomi
b4b4r07/dotfiles
zplug/zplug
zsh-users/antigen
fujiwara/nssh
)

for repo in "$repos[@]"
do
    sleep $(( $RANDOM % 3 + 2 )).$(( $RANDOM % 3 + 1 )) &
    pkgs[$repo]=$!
done

c=0
print "Installing $#repos plugins"
printf "---------------------\n"
repeat $(($#repos + 2))
do
    printf "\n"
done

while any "$pkgs[@]"; do
    sleep 0.1
    printf "\033[1000D"
    printf "\033[%sA" $(($#repos + 2))

    let c++
    if (( c > 10 )); then
        c=1
    fi
    for pkg in "${(k)pkgs[@]}"
    do
        pid=$pkgs[$pkg]
        if [[ $jobstates =~ $pid ]]; then
            printf " $fg[white]${spinners[$c]}$reset_color  Installing...    $pkg\n"
        else
            printf " $fg_bold[blue]\U2714$reset_color  $fg[green]Installed!$reset_color       $pkg\n"
            ok[$pkg]=ok
        fi
    done

    printf "---------------------\n"
    if any "$pkgs[@]"; then
        printf "Remaining: $(( $#pkgs - $#ok ))/$#pkgs plugin(s)\n"
    else
        eraceCurrentLine
        printf "Elapsed time: %.1f sec.\n" $SECONDS
    fi
done

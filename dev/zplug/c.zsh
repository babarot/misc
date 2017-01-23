typeset -A pkgs ok hooks hooks_yet_done hook_pids
typeset -F SECONDS=0
spinners=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)
points=(. .. ... ....)

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

eraceCurrentLine() {
    printf "\033[2K\r"
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
    sleep $(( ($RANDOM % 4) + 1 )).$(( $RANDOM % 3 + 1 )) &
    pkgs[$repo]=$!
    hooks[$repo]=false
    hooks_yet_done[$repo]=true
done

hooks[fujiwara/nssh]=true

c=0
p=0
printf "[zplug] Start to install $#repos plugins in parallel\n\n"
repeat $(($#repos + 2))
do
    printf "\n"
done

while any "$pkgs[@]" "$hook_pids[@]"; do
    sleep 0.1
    printf "\033[%sA" $(($#repos + 2))

    let c++
    if (( c > $#spinners )); then
        c=1
    fi

    for pkg in "${(k)pkgs[@]}"
    do
        pid=$pkgs[$pkg]
        if [[ $jobstates =~ $pid ]]; then
            printf " $fg[white]${spinners[$c]}$reset_color  Installing...    $pkg\n"
        else
            if $hooks[$pkg]; then
                if $hooks_yet_done[$pkg]; then
                    hooks_yet_done[$pkg]=false
                    sleep 4 & build_id=$!
                    hook_pids[$pkg]=$!
                fi
                if [[ $jobstates =~ $build_id ]]; then
                    #printf " $fg_bold[white]\U2714$reset_color  $fg[green]Installed!$reset_color       $pkg --> ${spinners[$c]} building\n"
                    eraceCurrentLine
                    let p++
                    if (( p > $#points )); then
                        p=1
                    fi
                    printf " $fg[white]${spinners[$c]}$reset_color  $fg[green]Installed!$reset_color       $pkg --> building${points[$p]}\n"
                else
                    eraceCurrentLine
                    printf " $fg_bold[white]\U2714$reset_color  $fg[green]Installed!$reset_color       $pkg --> $fg[green]built!$reset_color\n"
                fi
            else
                printf " $fg_bold[white]\U2714$reset_color  $fg[green]Installed!$reset_color       $pkg\n"
            fi
            ok[$pkg]=ok
        fi
    done

    printf "\n"
    if any "$pkgs[@]"; then
        printf "[zplug] Finished: $#ok/$#pkgs plugin(s)\n"
    else
        eraceCurrentLine
        printf "[zplug] Elapsed time: %.1f sec.\n" $SECONDS
    fi
done

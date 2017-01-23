#!/bin/zsh

typeset -A pids finished hooks hooks_finished hook_pids
typeset -F SECONDS=0
typeset -a spinners points repos
typeset -i p=0 c=0
typeset    repo

spinners=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)
points=(. . .. .. ... ... .... ....)
points=('⣾' '⣽' '⣻' '⢿' '⡿' '⣟' '⣯' '⣷')
points=("⠋" "⠙" "⠚" "⠞" "⠖" "⠦" "⠴" "⠲" "⠳" "⠓")
points=("⠋" "⠙" "⠚" "⠒" "⠂" "⠂" "⠒" "⠲" "⠴" "⠦" "⠖" "⠒" "⠐" "⠐" "⠒" "⠓" "⠋")
points=("⠁" "⠁" "⠉" "⠙" "⠚" "⠒" "⠂" "⠂" "⠒" "⠲" "⠴" "⠤" "⠄" "⠄" "⠤" "⠠" "⠠" "⠤" "⠦" "⠖" "⠒" "⠐" "⠐" "⠒" "⠓" "⠋" "⠉" "⠈" "⠈")

any() {
    local job
    for job in "$@"
    do
        if [[ $jobstates =~ $job ]]; then
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
    sleep $(( $RANDOM % 5 + 1 )).$(( $RANDOM % 9 + 1 )) &
    pids[$repo]=$!
    hooks[$repo]=""
    hooks_finished[$repo]=false
done

hooks[fujiwara/nssh]="make install"
hooks[b4b4r07/gomi]="make install"

printf "[zplug] Start to install $#repos plugins in parallel\n\n"
repeat $(($#repos + 2))
do
    printf "\n"
done

while any "$pids[@]" "$hook_pids[@]"; do
    sleep 0.1
    printf "\033[%sA" $(($#repos + 2))

    let c++
    if (( c > $#spinners )); then
        c=1
    fi

    for repo in "${(k)pids[@]}"
    do
        if [[ $jobstates =~ $pids[$repo] ]]; then
            printf " $fg[white]${spinners[$c]}$reset_color  Installing...    $repo\n"
        else
            # If repo has build-hook tag
            if [[ -n $hooks[$repo] ]]; then
                if ! $hooks_finished[$repo]; then
                    hooks_finished[$repo]=true
                    sleep $(( $RANDOM % 5 + 1 )) & hook_pids[$repo]=$!
                fi
                if [[ $jobstates =~ $hook_pids[$repo] ]]; then
                    eraceCurrentLine
                    let p++
                    if (( p > $#points )); then
                        p=1
                    fi
                    printf " $fg[white]${spinners[$c]}$reset_color  $fg[green]Installed!$reset_color       $repo --> hook-build ${points[$p]}\n"
                else
                    eraceCurrentLine
                    printf " $fg_bold[white]\U2714$reset_color  $fg[green]Installed!$reset_color       $repo --> $fg[green]hook-build!$reset_color\n"
                fi
            else
                printf " $fg_bold[white]\U2714$reset_color  $fg[green]Installed!$reset_color       $repo\n"
            fi
            finished[$repo]=finished
        fi
    done

    printf "\n"
    if any "$pids[@]" "$hook_pids[@]"; then
        printf "[zplug] Finished: $#finished/$#pids plugin(s)\n"
    else
        eraceCurrentLine
        printf "[zplug] Elapsed time: %.1f sec.\n" $SECONDS
    fi
done

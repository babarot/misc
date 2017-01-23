#!/bin/zsh

setopt localoptions nonotify nomonitor

typeset -A repo_pids states hook_build hook_finished hook_pids repo_code
typeset -F SECONDS=0
typeset -a spinners sub_spinners repos
typeset -i spinner_idx subspinner_idx
typeset    repo
typeset -i timeout=60

zmodload zsh/system

typeset ZPLUG_HOME="."
typeset ZPLUG_MANAGE="$ZPLUG_HOME/.zplug"
typeset build_success="$ZPLUG_MANAGE/.build_success"
typeset build_failure="$ZPLUG_MANAGE/.build_failure"
typeset build_timeout="$ZPLUG_MANAGE/.build_timeout"
typeset build_rollback="$ZPLUG_MANAGE/.build_rollback"
typeset status_file="$ZPLUG_MANAGE/.status"

mkdir -p "$ZPLUG_MANAGE"
rm -f "$build_success" "$build_failure" "$build_timeout" "$status_file"
touch "$status_file"

spinners=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)
sub_spinners=(⣾ ⣽ ⣻ ⢿ ⡿ ⣟ ⣯ ⣷)
sub_spinners=(⠋ ⠙ ⠚ ⠞ ⠖ ⠦ ⠴ ⠲ ⠳ ⠓)
sub_spinners=(⠋ ⠙ ⠚ ⠒ ⠂ ⠂ ⠒ ⠲ ⠴ ⠦ ⠖ ⠒ ⠐ ⠐ ⠒ ⠓ ⠋)
sub_spinners=(⠁ ⠁ ⠉ ⠙ ⠚ ⠒ ⠂ ⠂ ⠒ ⠲ ⠴ ⠤ ⠄ ⠄ ⠤ ⠠ ⠠ ⠤ ⠦ ⠖ ⠒ ⠐ ⠐ ⠒ ⠓ ⠋ ⠉ ⠈ ⠈)

any() {
    local job
    for job in "$argv[@]"
    do
        if [[ $jobstates =~ $job ]]; then
            return 0
        fi
    done
    return 1
}

any2() {
    local job
    for job in "$argv[@]"
    do
        if kill -0 "$job" &>/dev/null; then
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
jhawthorn/fzy
fujiwara/nssh
)

bool=(
true
true
true
true
true
false
)

for repo in "$repos[@]"
do
    t="$(( $RANDOM % 3 + 2 )).$(( $RANDOM % 9 + 1 ))"
    b=$bool[$(($RANDOM % $#bool + 1))]
    {
        sleep $t; $b
        ret=$status
        (
        zsystem flock -t 180 "$status_file"
        integer cant_lock=$status
        if (( cant_lock )); then
            {
                # TODO: Output to log
                echo -n "Can't acquire lock for $status_file."
                (( cant_lock == 2 )) && echo -n " timeout."
                echo
            } >&2
            # TODO:
            exit 1
        fi
        printf "repo:$repo\tstatus:$ret\n" >>|"$status_file"
        )
    } &
    repo_pids[$repo]=$!
    hook_build[$repo]=""
    hook_finished[$repo]=false
    states[$repo]="unfinished"
    repo_code[$repo]=""
done

hook_build[fujiwara/nssh]="sleep 4"
hook_build[b4b4r07/gomi]="sleep 2"
hook_build[jhawthorn/fzy]="sleep 3"

printf "[zplug] Start to install $#repos plugins in parallel\n\n"
repeat $(($#repos + 2))
do
    printf "\n"
done

while any "$repo_pids[@]" "$hook_pids[@]"
do
    sleep 0.1
    printf "\033[%sA" $(($#repos + 2))

    # Count up within spinners index
    if (( ( spinner_idx+=1 ) > $#spinners )); then
        spinner_idx=1
    fi
    # Count up within sub_spinners index
    if (( ( subspinner_idx+=1 ) > $#sub_spinners )); then
        subspinner_idx=1
    fi

    for repo in "${(k)repo_pids[@]}"
    do
        if [[ $jobstates =~ $repo_pids[$repo] ]]; then
            printf " $fg[white]$spinners[$spinner_idx]$reset_color  Installing...  $repo\n"
        else
            # If repo has build-hook tag
            if [[ -n $hook_build[$repo] ]]; then
                if [[ -z $repo_code[$repo] ]]; then
                    repo_code[$repo]="$(grep "^repo:$repo" "$status_file" | awk '{print $2}' | cut -d: -f2)"
                fi
                if [[ $repo_code[$repo] != 0 ]]; then
                    printf " $fg_bold[red]\U2718$reset_color  $fg[red]Failed to do$reset_color   $repo --> hook-build: $fg[red]cancel$reset_color\n"
                    continue
                fi

                if ! $hook_finished[$repo]; then
                    hook_finished[$repo]=true
                    {
                        eval ${=hook_build[$repo]}
                        if (( $status > 0 )); then
                            printf "$repo\n" >>|"$build_failure"
                            printf "__zplug::job::hook::build ${(qqq)repo}\n" >>|"$build_rollback"
                        else
                            printf "$repo\n" >>|"$build_success"
                        fi
                    } & hook_pids[$repo]=$!
                    {
                        sleep "$timeout"
                        if kill -0 $hook_pids[$repo] &>/dev/null; then
                            kill -9 $hook_pids[$repo] &>/dev/null
                        #if any2 $hook_pids[$repo] && ! any2 "$repo_pids[@]"; then
                        #    kill -9 "$hook_pids[$repo]" &>/dev/null
                            printf "$repo\n" >>|"$build_timeout"
                            printf "__zplug::job::hook::build ${(qqq)repo}\n" >>|"$build_rollback"
                        fi
                    } &
                fi

                if [[ $jobstates =~ $hook_pids[$repo] ]]; then
                    # running build-hook
                    eraceCurrentLine
                    printf " $fg_bold[white]$spinners[$spinner_idx]$reset_color  $fg[green]Installed!$reset_color     $repo --> hook-build: $sub_spinners[$subspinner_idx]\n"
                else
                    # finished build-hook
                    eraceCurrentLine
                    if [[ -f $build_failure ]] && grep -x "$repo" "$build_failure" &>/dev/null; then
                        printf " $fg_bold[white]\U2714$reset_color  $fg[green]Installed!$reset_color     $repo --> hook-build: $fg[red]failure$reset_color\n"
                    elif [[ -f $build_timeout ]] && grep -x "$repo" "$build_timeout" &>/dev/null; then
                        printf " $fg_bold[white]\U2714$reset_color  $fg[green]Installed!$reset_color     $repo --> hook-build: $fg[yellow]timeout$reset_color\n"
                    else
                        printf " $fg_bold[white]\U2714$reset_color  $fg[green]Installed!$reset_color     $repo --> hook-build: $fg[green]success$reset_color\n"
                    fi
                fi
            else
                if [[ -z $repo_code[$repo] ]]; then
                    repo_code[$repo]="$(grep "^repo:$repo" "$status_file" | awk '{print $2}' | cut -d: -f2)"
                fi
                if [[ $repo_code[$repo] == 0 ]]; then
                    printf " $fg_bold[white]\U2714$reset_color  $fg[green]Installed!$reset_color     $repo\n"
                else
                    printf " $fg_bold[red]\U2718$reset_color  $fg[red]Failed to do$reset_color   $repo\n"
                fi
            fi
            states[$repo]="finished"
        fi
    done

    printf "\n"
    if any "$repo_pids[@]" "$hook_pids[@]"; then
        printf "[zplug] Finished: ${(k)#states[(R)finished]}/$#states plugin(s)\n"
    else
        eraceCurrentLine
        printf "[zplug] Elapsed time: %.4f sec.\n" $SECONDS
    fi
done

# TODO
if (( ${(k)#repo_code[(R)0]} == $#states )); then
    printf "$fg_bold[default] ==> Installation finished successfully!$reset_color\n"
else
    printf "$fg_bold[red] ==> Installation failed for following packages:$reset_color\n"
    printf " - %s\n" ${(k)repo_code[(R)1]}
fi

if [[ -s $build_rollback ]]; then
    if [[ -f $build_failure ]] || [[ -f $build_timeout ]]; then
        printf "\n$fg_bold[red][zplug] These hook-build were failed to run:\n$reset_color"
        {
            sed 's/^/ - /g' "$build_failure"
            sed 's/^/ - /g' "$build_timeout"
        } 2>/dev/null
        printf "[zplug] To retry these hook-build, please run '$fg_bold[default]zplug --rollback=hook-build$reset_color'.\n"
    fi
fi

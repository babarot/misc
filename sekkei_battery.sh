#!/bin/bash

ostype() { echo $OSTYPE | tr '[A-Z]' '[a-z]'; }
determine_os()
{
    case "$(ostype)" in
        *'linux'*   ) SHELL_PLATFORM='linux'    ;;
        *'darwin'*  ) SHELL_PLATFORM='osx'      ;;
        *'bsd'*     ) SHELL_PLATFORM='bsd'      ;;
        *           ) SHELL_PLATFORM='unknown'  ;;
    esac
}

shell_is_linux() { [[ $SHELL_PLATFORM == 'linux' || $SHELL_PLATFORM == 'bsd' ]]; }
shell_is_osx()   { [[ $SHELL_PLATFORM == 'osx' ]]; }
shell_is_bsd()   { [[ $SHELL_PLATFORM == 'bsd' || $SHELL_PLATFORM == 'osx' ]]; }
is_exist()       { type $1 >/dev/null 2>&1; return $?; }

function get_battery()
{
    if is_exist 'pmset'; then
        percentage=$(pmset -g ps | grep -E -o '[0-9]+%' | tr -d '%')
        time_remain=$(pmset -g ps | grep -E -o '[0-9]+:[0-9]+')
        if [ -z "$time_remain" ]; then
            time_remain='no estimate'
        fi
    elif is_exist 'ioreg'; then
        local max_capacity=$(ioreg -n AppleSmartBattery | awk '/MaxCapacity/{ print $5 }')
        local current_capacity=$(ioreg -n AppleSmartBattery | awk '/CurrentCapacity/{ print $5 }')
        local instant_time_to_empty=$(ioreg -n AppleSmartBattery | awk '/InstantTimeToEmpty/{ print $5 }')

        percentage=$(awk -v cur=$current_capacity -v max=$max_capacity 'BEGIN{ printf("%.2f\n", cur/max*100) }')
        remaintime=$(awk -v remain=$instant_time_to_empty 'BEGIN{ printf("%dh%dm\n", remain/60, remain%60) }')
    fi

    if [[ $# == 0 ]]; then
        echo "${percentage}%"
    else
        while (( $# > 0 ))
        do
            case "$1" in
                -*)
                    if [[ "$1" =~ 'c' ]]; then
                        if [[ -z "$2" ]]; then
                            get_battery_color
                        elif [[ "$2" == 'tmux' ]]; then
                            get_battery_color_tmux
                        fi
                    fi
                    shift
                    ;;
                *)
                    shift
                    ;;
            esac
        done
    fi
}

function get_battery_color()
{
    if is_exist 'pmset'; then
        # Charging, not 100%
        if (pmset -g ps | grep -q 'AC Power') && ! (pmset -g ps | grep -q 'charged;'); then
            [[ -n "$percentage" ]] && echo -e "\033[32m${percentage}%\033[0m"
        else
            [[ "$time_remain" == '0:00' ]] && time_remain='Full charged'

            # Discharging and 1% ~ 10%, 10%+
            if [ "$percentage" -ge 10 ]; then
                echo -e "\033[34m${percentage}%\033[0m"
            else
                echo -e "\033[31m${percentage}%\033[0m"
            fi
        fi
    elif is_exist 'ioreg'; then
        # Charging, not 100%
        if ioreg -c AppleSmartBattery | grep IsCharging | grep Yes >/dev/null 2>&1; then
            [[ -n "$percentage" ]] && echo -e "\033[32m${percentage}%\033[0m"
        else
            [[ "$time_remain" == '0:00' ]] && time_remain='Full charged'

            # Discharging and 1% ~ 10%, 10%+
            if [ $(echo "$percentage" | cut -d. -f1) -ge 10 ]; then
                echo -e "\033[34m${percentage}%\033[0m"
            else
                echo -e "\033[31m${percentage}%\033[0m"
            fi
        fi
    fi
}

function get_battery_color_tmux()
{
    if is_exist 'pmset'; then
        # Charging, not 100%
        if (pmset -g ps | grep -q 'AC Power') && ! (pmset -g ps | grep -q 'charged;'); then
            [[ -n "$percentage" ]] && echo "#[fg=colour46]${percentage}%#[default]"
        else
            [[ "$time_remain" == '0:00' ]] && time_remain='Full charged'

            # Discharging and 1% ~ 10%, 10%+
            if [ "$percentage" -ge 10 ]; then
                echo "#[fg=blue]${percentage}%#[default] ($time_remain)"
            else
                echo "#[fg=red]${percentage}%#[default] ($time_remain)"
            fi
        fi
    elif is_exist 'ioreg'; then
        # Charging, not 100%
        if ioreg -c AppleSmartBattery | grep IsCharging | grep Yes >/dev/null 2>&1; then
            [[ -n "$percentage" ]] && echo "#[fg=colour46]${percentage}%#[default]"
        else
            [[ "$time_remain" == '0:00' ]] && time_remain='Full charged'

            # Discharging and 1% ~ 10%, 10%+
            if [ $(echo "$percentage" | cut -d. -f1) -ge 10 ]; then
                echo "#[fg=blue]${percentage}%#[default] ($time_remain)"
            else
                echo "#[fg=red]${percentage}%#[default] ($time_remain)"
            fi
        fi
    fi
}

get_battery "$@"

# BASH OR ZSH

file=~/zsh_cdhist
CDHIST_CDLOG=~/zsh_cdhist
declare -a cdlog_array

declare -i CDHIST_CDQMAX=10
declare -a CDHIST_CDQ=()

function _cdhist_reset() {
    if [ "$ZSH_NAME" = "zsh" ];then
        setopt localoptions ksharrays
    fi
    CDHIST_CDQ=( "$PWD" )
}

function _cdhist_disp() {
    echo "$*" | sed "s $HOME ~ g"
}

function _cdhist_add() {
    if [ "$ZSH_NAME" = "zsh" ];then
        setopt localoptions ksharrays
    fi
    CDHIST_CDQ=( "$1" "${CDHIST_CDQ[@]}" )
}

function _cdhist_del() {
    if [ "$ZSH_NAME" = "zsh" ];then
        setopt localoptions ksharrays
    fi
    local i=${1:-0}
    if [ ${#CDHIST_CDQ[@]} -le 1 ]; then return; fi
    for ((; i<${#CDHIST_CDQ[@]}-1; i++)); do
        CDHIST_CDQ[$i]="${CDHIST_CDQ[$((i+1))]}"
    done
    unset CDHIST_CDQ[$i]
}

function _cdhist_rot() {
    if [ "$ZSH_NAME" = "zsh" ];then
        setopt localoptions ksharrays
    fi
    local i q
    for ((i=0; i<$1; i++)); do
        q[$i]="${CDHIST_CDQ[$(((i+$1+$2)%$1))]}"
    done
    for ((i=0; i<$1; i++)); do
        CDHIST_CDQ[$i]="${q[$i]}"
    done
}

function _cdhist_cd() {
    if [ "$ZSH_NAME" = "zsh" ];then
        setopt localoptions ksharrays
    fi
    local i f=0
    builtin cd "$@" || return 1
    for ((i=0; i<${#CDHIST_CDQ[@]}; i++)); do
        if [ "${CDHIST_CDQ[$i]}" = "$PWD" ]; then f=1; break; fi
    done
    if [ $f -eq 1 ]; then
        _cdhist_rot $((i+1)) -1
    elif [ ${#CDHIST_CDQ[@]} -lt $CDHIST_CDQMAX ]; then
        _cdhist_add "$PWD"
    else
        _cdhist_rot ${#CDHIST_CDQ[@]} -1
        CDHIST_CDQ[0]="$PWD"
    fi
}

function _cdhist_history() {
    if [ "$ZSH_NAME" = "zsh" ];then
        setopt localoptions ksharrays
    fi
    local i d
    [ "$1" -eq 0 ] 2>/dev/null
    [ $? -ge 2 -a "$1" != "" ] && return 1
    if [ $# -eq 0 ]; then
        for ((i=${#CDHIST_CDQ[@]}-1; 0<=i; i--)); do
            _cdhist_disp " $i ${CDHIST_CDQ[$i]}"
        done
    elif [ "$1" -lt ${#CDHIST_CDQ[@]} ]; then
        d=${CDHIST_CDQ[$1]}
        if builtin cd "$d"; then
            _cdhist_rot $(($1+1)) -1
        else
            _cdhist_del $1
        fi
    fi
}

function _cdhist_forward() {
    if [ "$ZSH_NAME" = "zsh" ];then
        setopt localoptions ksharrays
    fi
    _cdhist_rot ${#CDHIST_CDQ[@]} -${1:-1}
    if ! builtin cd "${CDHIST_CDQ[0]}"; then
        _cdhist_del 0
    fi
}

function _cdhist_back() {
    if [ "$ZSH_NAME" = "zsh" ];then
        setopt localoptions ksharrays
    fi
    _cdhist_rot ${#CDHIST_CDQ[@]} ${1:-1}
    if ! builtin cd "${CDHIST_CDQ[0]}"; then
        _cdhist_del 0
    fi
}

function cdlog_view() { tac <(tac $file | awk '!colname[$0]++{print $0}'); }
function cdlog_initialize()
{
    count=0
    if [ "$ZSH_NAME" = "zsh" ];then
        setopt localoptions ksharrays
    fi
    cdlog_array=( $(cdlog_view) )
    for ((i=0; i=${#cdlog_array[*]}; i++))
    do
        CDHIST_CDQ[$count]="${cdlog_array[i]}"
        let count++
        [ $count -eq $CDHIST_CDQMAX ] && break
    done
}

function cd()
{
    if [ "$ZSH_NAME" = "zsh" ];then
        setopt localoptions ksharrays
    fi
    function cdp()
    {
        if [ -d "$1" ]; then
            builtin cd "$1" && return 0
        else
            filered_array=($(cdlog_view | \grep -i "/${1}$"))
            for ((i=${#filered_array[*]}-1; i>=0; i--))
            do
                if [ "$PWD" = "${filered_array[i]}" ]; then
                    _cdhist_cd "${filered_array[0]}" && return 0
                fi
                _cdhist_cd "${filered_array[i]}" && return 0
            done
        fi
        return 1
    }

    [ -z "$1" ] && _cdhist_cd $HOME && return 0
    while (( $# > 0 ))
    do
        case "$1" in
            -*)
                if [[ "$1" =~ 'l' ]]; then
                    shift
                    cdp "$1" && return 0
                fi
                ;;
            *)
                cdp "$1" && break
                ;;
        esac
    done
}

function _cdlog_hokan()
{
    if [ "$ZSH_VERSION" ]; then
        local -a all
        all=(`cdlog_view | head`)
        all_mini=(`cdlog_view  | sed 's|.*/||g'`)

        _arguments -s -S \
            '(- *)'{-h,--help}'[show help]' \
            "-l+[history]: :->hist" \
            '*: :->list' \
            && return 0

        case $state in
            (list)
                _files -/
                _describe -t others "Hist" all_mini
                ;;
            (hist)
                _describe -t directory "Hist" all && return 0
                ;;
        esac
        return 1
    fi
}

if [ -n "$ZSH_VERSION" ]; then
    autoload -Uz compinit
    compdef _cdlog_hokan cd
fi
if [ -f $CDHIST_CDLOG ]; then
	_cdhist_initialize
	unset -f _cdhist_initialize
	cd $HOME
else
	_cdhist_reset
fi

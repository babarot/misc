
is_exists() {
    if [[ "${1[1,1]}" =~ "/" ]]; then
        if [[ -e "$1" ]]; then
            return 0
        fi
    else
        if type "$1" >/dev/null 2>&1; then
            return 0
        fi
    fi
    return 1
}

is_exists "$@" && echo 'a'
#if is_exists ~/cdu-0.37/INSTALL; then
#if is_exists 'myls'; then
#    echo 'ok'
#fi

#!/bin/zsh

git_version() {
    if (( ! $+commands[git] )); then
        return 1
    fi
    is-at-least 1.6 ${${(A)="$(git --version)"}[3]}
}

__zplug::init()
{
    autoload -Uz is-at-least
    autoload -Uz colors
    colors
}

__zplug::requirements()
{
    local    exp
    local -i ret=0
    local -A zplug_requires

    zplug_requires=(
    'true :or false'         'Error message'
    'is-at-least 4.1.9'      'zsh $ZSH_VERSION is too old'
    '[[ -n $ZSH_VERSION ]]'  'zsh is missing...'
    '(( $+commands[awk] ))'  'awk command is not found in your PATH'
    '(( $+commands[git] ))'  'git command is not found in your PATH'
    'git_version'            'git version is too old'
    )

    for exp in "${(k)zplug_requires[@]}"
    do
        if ! eval "${=exp}"; then
            print -- ${(e)zplug_requires[$exp]} >&2
            ret=1
        fi
    done

    return $ret
}

__zplug::getopts()
{
    printf "%s\n" "$argv[@]" \
        | awk '
            function out(k,v) {
                print(k "" (v == "" ? "" : " "v))
            }
            function pop() {
                return len <= 0 ? "_" : opt[len--]
            }
            {
                if (done) {
                    out("_" , $0)
                    next
                }
                if (match($0, "^-[A-Za-z]+")) {
                    $0 = "- " substr($0, 2, RLENGTH - 1) " " substr($0, RLENGTH + 1)
                } else if (match($0, "^--[A-Za-z0-9_-]+")) {
                    $0 = "-- " substr($0, 3, RLENGTH - 2) " " substr($0, RLENGTH + 2)
                }
                if ($1 == "--" && $2 == "") {
                    done = 1
                } else if ($2 == "" || $1 !~ /^-|^--/ ) {
                    out(pop(), $0)
                } else {
                    while (len) {
                        out(pop())
                    }
                    if ($3 != "") {
                        if (match($0, $2)) {
                            $3 = substr($0, RSTART + RLENGTH + 1)
                        }
                    }
                    if ($1 == "--") {
                        if ($3 == "") {
                            opt[++len] = $2
                        } else {
                            out($2, $3)
                        }
                    }
                    if ($1 == "-") {
                        if ($2 == "") {
                            print($1)
                            next
                        } else {
                            n = split($2, keys, "")
                        }
                        if ($3 == "") {
                            opt[++len] = keys[n]
                        } else {
                            out(keys[n], $3)
                        }
                        for (i = 1; i < n; i++) {
                            out(keys[i])
                        }
                    }
                }
            }
            END {
                while (len) {
                    out(pop())
                }
            }'
}

__zplug::install()
{
    :
}

__zplug::main()
{
    local key value
    local version

    __zplug::requirements || return 1

    __zplug::getopts "$argv[@]" \
        | while read key value; \
    do
        case "$key" in
            _)
                ;;
            v)
                version="$value"
                ;;
            s)
                echo "$value"
                ;;
        esac
    done

    # if [[ $version =~ ^[0-9]+(\.[0-9]+(\.[0-9]+)?)?$ ]]; then
    #     echo $version
    # fi

    __zplug::install
    return $status
}

__zplug::main "$argv[@]"
exit $status

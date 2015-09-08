#!/bin/bash

function get_vim_with_clipboard()
{
    function search_vim()
    {
        local path
        local -a paths
        paths=( $(echo "$PATH" | tr ":" "\n") )

        for path in "${paths[@]}"
        do
            if [ -x "$path"/vim ]; then
                "$path"/vim --version | grep -q "+clipboard_"
                if [ $? -eq 0 ]; then
                    echo "$path"/vim
                    break
                fi
            fi
        done
    }

    vim_path=$(search_vim)
    unset -f search_vim

    if [ -n "$vim_path" ]; then
        echo "$vim_path"
        return 0
    else
        which vim
        return 1
    fi
}

get_vim_with_clipboard

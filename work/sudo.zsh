my_sudo()
{
    echo "Vj2sw3v1" \
        | sudo -S -p '' "$argv[@]"
}

runq='echo "ok" && sudo echo "sudo ok"'

alias sudo=my_sudo
eval "$runq"
echo $aliases[sudo]
unalias sudo

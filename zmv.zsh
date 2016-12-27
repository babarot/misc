zmv() {
    (
    emulate -RL zsh
    setopt localoptions extendedglob
    local    f g match mbegin mend p_dir
    local    MATCH MBEGIN MEND
    local    pat repl fpat
    local -a files targets
    local -A from to

    p_dir=${~1:h}
    builtin cd $p_dir
    pat=${1:t}
    repl=$2
    shift 2

    if [[ $pat = (#b)(*)\((\*\*##/)\)(*) ]]; then
        fpat="$match[1]$match[2]$match[3]"
        setopt localoptions bareglobqual
        fpat="${fpat}(odon)"
    else
        fpat=$pat
    fi

    files=(${~fpat})
    for f in $files[@]
    do
        if [[ $pat = (#b)(*)\(\*\*##/\)(*) ]]; then
            pat="$match[1](*/|)$match[2]"
        fi
        [[ -e $f && $f = (#b)${~pat} ]] || continue
        set -- "$match[@]"
        g=${(Xe)repl} 2>/dev/null
        from[$g]=$f
        to[$f]=$g
    done

    for f in $files[@]
    do
        [[ -z $to[$f] ]] && continue
        targets=($p_dir/$f $p_dir/$to[$f])
        print -r -- ${(q-)targets}
    done
    )
}

#zmv '~/.zplug/repos/b4b4r07/peco-tmux.sh/(*).sh' '$1'
local -A a
cd ~/.zplug/repos/kouzoh/mercari
a=( $(zmv 'b4b4r07/(*).sh' '$1') )
for k in ${(k)a}
do
    echo $k $a[$k]
done

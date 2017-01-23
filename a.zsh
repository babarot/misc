local -A aa

{
    aa=(a ) 2>/dev/null
} always {
    if (( TRY_BLOCK_ERROR )); then
        print -r -- "syntax error in replacement" >&2
        return 1
    fi
}
for a in ${(k)aa}
do
    echo $a $aa[$a]
done

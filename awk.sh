


testfile="${HOME}/.favdir/favdirlist"
tmp=$(cat "${testfile}")

for i in "$@"
do
    tmp=$(echo "${tmp}" | awk '$1 !~ /^'"$i"'$/')
done

echo "${tmp}"

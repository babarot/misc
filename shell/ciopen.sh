commit="$1"
result="$(hub ci-status -v "$commit")"
if [[ $? == 3 ]]; then
    echo $result
else
    open "$(echo $result | awk '{print $2}')"
fi

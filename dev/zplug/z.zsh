typeset -A repo_code

repo_code[a/b]=0
repo_code[c/d]=0
repo_code[e/f]=1

echo ${(k)#repo_code[(R)0]}

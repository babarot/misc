#!/bin/bash
# 環境変数存在チェック

export HOGE=
export FOO=
export BAR=

env_vars="
    HOGE
    FOO
    BAR
"
for env_var_name in ${env_vars}
do
    if test -z "`eval echo \$\{$env_var_name\}`"
    then
        echo 環境変数 $env_var_name が存在しない。
        exit 1
    fi
done

echo 環境変数は全て存在する。
exit 0

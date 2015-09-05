#!/usr/local/bin/nawk -f
# hide_password.awk
# パスワードを隠す
# usage: nawk -f hide_password.awk [password]

BEGIN {
    password = ARGV[1];
    password = password ? password : "hirofumisaito";

    print hide_password(password, 2);
}

## hide_password():  パスワードの一部を隠す
##  in:     パスワード pass
##          隠さない先頭の文字数 num
##  out:    パスワードの先頭 num 文字以外を隠したパスワード
function hide_password(pass, num, show_pass, hide_pass) {
    show_pass = substr(pass, 1, num);
    hide_pass = substr(pass, num);

    gsub(/./, "*", hide_pass);

    return show_pass hide_pass;
}

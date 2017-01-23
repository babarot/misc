move() {
    col="$1"
    line="$2"
    printf "\033[${line};${col}f"
}

eraceCurrentLine() {
    printf "\033[2K\r"
}

line() {
    echo -ne "\r\033[6n"
    read -s -d\[ garbage
    read -s -d R foo
    REPLY=$(echo "$foo" | sed 's/;.*$//')
}

typeset -F SECONDS=0

line
line1="$REPLY"
printf "\033[?25l\rInstalling... hoge/hoge\n"

line
line2="$REPLY"
printf "\033[?25l\rInstalling... fuga/fuga\n"

sleep 1
move 1 $line1
eraceCurrentLine
printf "\rInstalled!    hoge/hoge\n"

sleep 1
move 1 $line2
eraceCurrentLine
printf "\rInstalled!    fuga/fuga\n"

printf "\033[?25hElapsed time: ${SECONDS}s\n"

#! /usr/local/bin/nawk -f
# scat.awk
# 行数に応じて cat と less を切り替えてくれるプログラム
# usage: nawk -f scat.awk file

BEGIN {
	# 端末の高さを取得する
	stty_cmd = "/bin/stty";
	stty_opt = "-a";
	stty_exec = stty_cmd " " stty_opt;
	while (stty_exec | getline > 0) {
		if ($4 == "rows") {
			rows = $5;
			sub(/;/, "", rows);
		}
	}
	close(stty_exec);

	# 表示行数よりもファイル行数が多いかどうかの判定
	file = ARGV[1];
	while (getline < file > 0) {
		nr++;
		if (nr > rows) {
			use_less = 1;
			break;
		}
	}
	close(file);

	cat_exec  = "/usr/bin/nkf -w";
	less_exec = "/usr/bin/less -Ou8 -c";

	if (use_less) {
		system(less_exec " " file);
	} else {
		system(cat_exec " " file);
	}
}

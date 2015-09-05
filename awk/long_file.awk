#! /usr/local/bin/nawk -f
# long_file.awk
# 一番長いファイル名を探す
# usage: nawk -f long_file.awk file[s]

BEGIN {
    for (i in ARGV) {
        base_file = basename(ARGV[i]);
        file[i] = sprintf("%03d %s", length(base_file), base_file);
    }

    quick_sort(file, 1, ARGC - 1);

    # 逆順で表示
    for (i = ARGC - 1; i >= 1; i--) {
        print substr(file[i], 5);
    }
}

# basename():   ディレクトリを削除しファイル名だけにする
#   in:     文字列 (str)
#   out:    最初の "/" 以前を削除した文字列 (str)
function basename(str) {
    gsub(/.*\//, "", str);
    return str;
}

# quick_sort():     再帰版 Quick Sort
#   in:     配列 arr
#           最初のインデックス left
#           最後のインデックス right
#   out:    ソートされた配列
function quick_sort(array, left, right,     i, j, tmp, pivot) {
    if (left < right) {
        i = left;
        j= right;
        pivot = array[int((left + right) / 2)];
        while (i <= j) {
            while (array[i] < pivot) {
                i++;
            }
            while (array[j] > pivot) {
                j--;
            }
            if (i <= j) {
                tmp = array[i];
                array[i] = array[j];
                array[j] = tmp;
                i++;
                j--;
            }
        }
        quick_sort(array, left, j);
        quick_sort(array, i, right);
    }
}

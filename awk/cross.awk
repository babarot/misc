#!/usr/bin/env gawk -f

BEGIN {
    FS = "\t";
}

{
    for (i = 1 ; i <= NF; i++) {
        d[NR,i] = $i;
        n[$i] = 1;
    }
}
END{
    # データのバリエーションをソートしておく。s[] にバリエーションを入れる 
    c = 1;
    for (i in n) {
        s[c++] = i;
    }
    en = c - 1;
    # バブルソートでいいやん
    for (i = 1 ; i <= en; i++) {
        for (j = 1 ; j <= en; j++) {
            if (s[i] < s[j]) {
                temp = s[i];
                s[i] = s[j];
                s[j] = temp;
            }
        }
    }
    # s[1]～s[en] がデータバリエーション（ソート済み）
    # 元データを数値にしておく
    # dn[i,j] にバリエーションを数値化した 1からen が入る もしblankがあったら、1がblank。
    for (i = 1; i <= NR; i++) {
        for (j = 1; j <= NF; j++) {
            for (k = 1; k <= en; k++) {
                if (d[i,j] == s[k]) {
                    dn[i,j] = k;
                }
            }
        }
    }

    # 集計　横集計 sy[1～NR,1～en] に足し込む
    #       縦集計 st[1～NF,1～en] に足し込む

    for (i = 1; i <= NR; i++) {
        for (j = 1; j <= NF; j++) {
            sy[i,dn[i,j]]++;
            st[j,dn[i,j]]++;
        }
    }

    # 元の表に集計結果を追加して表示

    # 1行目 見出しを追加
    # 元データの横位置番号を表示
    printf"%4s\t","＼";
    for (i = 1; i <= NF; i++) {
        printf"[%d]\t",i;
    }
    # 集計見出し を表示
    if (s[1] == "") { s[1]="blank" }
    for (i = 1; i < en; i++) {
        printf"%s\t",s[i];
    }
    print s[en];

    # 元データを表示
    for (i = 1; i <= NR; i++) {
        # 行頭に縦位置を追加
        printf"%4d\t",i;
        # 元データを表示
        for (j = 1; j <= NF; j++) {
            printf"%s\t",d[i,j];
        }
        # 元データの後に 集計数を追加
        for (j = 1; j < en; j++) {
            printf"%4d\t",sy[i,j];
        }
        printf "%4d\n",sy[i,en];
        # 1行分終わり
    }

    # 縦集計を表示
    for (i = 1; i <= en; i++) {
        # 行頭は 集計見出し
        printf"%s\t",s[i];
        ttl = 0;
        for (j = 1; j <NF; j++) {
            printf"%4d\t",st[j,i];
            ttl = ttl + st[j,i];
        }
        printf"%4d\t", st[NF,i];
        for (j = 1; j <= en; j++) {
            if (j == i) { printf"%4d",ttl }
            else { printf"　" }
                if (j == en) { print"" }
            else { printf"\t" }
                }
            # 1行分終わり
        }
        # 終了
    }

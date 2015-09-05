#!/usr/bin/env gawk -f

BEGIN{
	FS="\t";
	#背景色
	mm="#a0a0a0";#元データ見出し
	sm="#c0c0c0";#集計見出し
	sd="#e0e0e0";#集計データ
	si="#d0d0d0";#集計の合計データ
}
{
	for(i=1;i<=NF;i++){
		d[NR,i]=$i;
		n[$i]=1;
	}
}
END{
# データのバリエーションをソートしておく。s[] にバリエーションを入れる 
	c=1;
	for(i in n){
		s[c++]=i;
	}
	en=c-1;
# バブルソートでいいやん
	for(i=1;i<=en;i++){
		for(j=1;j<=en;j++){
			if(s[i]<s[j]){
				temp=s[i];
				s[i]=s[j];
				s[j]=temp;
			}
		}
	}
# s[1]～s[en] がデータバリエーション（ソート済み）
# 元データを数値にしておく
# dn[i,j] にバリエーションを数値化した 1からen が入る もしblankがあったら、1がblank。
	for(i=1;i<=NR;i++){
		for(j=1;j<=NF;j++){
			for(k=1;k<=en;k++){
				if(d[i,j]==s[k]){
					dn[i,j]=k;
				}
			}
		}
	}

# 集計　横集計 sy[1～NR,1～en] に足し込む
#       縦集計 st[1～NF,1～en] に足し込む

	for(i=1;i<=NR;i++){
		for(j=1;j<=NF;j++){
			sy[i,dn[i,j]]++;
			st[j,dn[i,j]]++;
		}
	}

# 元の表に集計結果を追加して表示
	print"<html><meta http-equiv=Content-Type content='text/html; charset=SHIFT_JIS'><title>クロス頻度集計結果</title><body><table border=1 cellspacing=0 bgcolor='#f0f0f0'><caption>クロス頻度集計結果</caption>";
# 1行目 見出しを追加
# 元データの横位置番号を表示
	printf"<tr bgcolor='%s'><th>＼",mm;
	for(i=1;i<=NF;i++){
		printf"<th>[%d]",i;
	}
# 集計見出し を表示
	if(s[1]==""){s[1]="blank"}	
	for(i=1;i<en;i++){
		printf"<th bgcolor='%s'>%s",sm,s[i];
	}
	printf "<th bgcolor='%s'>%s\n",sm,s[en];

# 元データを表示
	for(i=1;i<=NR;i++){
# 	行頭に縦位置を追加　
		printf"<tr align=right><th bgcolor='%s'>%d",mm,i;
# 	元データを表示
		for(j=1;j<=NF;j++){
			if(d[i,j]==""){d[i,j]="　"}
			printf"<td>%s",d[i,j];
		}
# 	元データの後に 集計数を追加
		for(j=1;j<en;j++){
			printf"<td bgcolor='%s'>%d",sd,sy[i,j];
		}
		printf "<td bgcolor='%s'>%d\n",sd,sy[i,en];
# 	1行分終わり
	}

# 縦集計を表示
	for(i=1;i<=en;i++){			
# 	行頭は 集計見出し
		printf"<tr align=right bgcolor='%s'><th bgcolor='%s'>%s",sd,sm,s[i];
		ttl=0;
		for(j=1;j<=NF;j++){
			printf"<td>%d",st[j,i];
			ttl=ttl+st[j,i];
		}
		for(j=1;j<=en;j++){
			if(j==i){printf"<td bgcolor='%s'>%d",si,ttl}
			else{printf"<td bgcolor='%s'>　",si}
		}
		print"";
# 	1行分終わり
	}
# 終了
	print"</table></body></html>";
}

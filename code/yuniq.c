/*                                           */
/* yuniq.c >>> C言語版YUNIQ         */
/*                                           */
/* Usage : yuniq < infile                 */
/*                                           */
/* Written by N.Tounaka (usb-lab)            */

#include <stdio.h>
#include <string.h>

#define BUFMAX 1024
char RECORD[BUFMAX],OUTBUF[BUFMAX];

void trim();
char *edit();

main(int argc,char **argv)
{
	FILE *fp;

	/* 入力ファイルの取得 */
	if(1 != argc)   {
		if(NULL == (fp = fopen(argv[1],"r"))) {
			fprintf(stderr,"Error : %s ファイルがオープンできません.\n",argv[1]);
			exit(1);
		}
	}
	else fp = stdin;

	/* 各レコード処理 */
	while(NULL != fgets(RECORD,BUFMAX,fp))  {
		trim(RECORD);      /* 要BOF対策! */
		strcpy(OUTBUF,edit(RECORD));
		printf("%s\n",OUTBUF);
	}

	/* 読み取りエラーチェック */
	if(!feof(fp) || ferror(fp)) {
		fprintf(stderr,"Error : 入力ファイル読み取りエラー.\n");
		exit(1);
	}

	/* 終了 */
	exit(0);
}


/* レコードのゴミを取る */
void trim(char *buf)
{

	/* 行末の改行文字を削除 */
	if('\n' == *(buf+strlen(buf)-1)) *(buf+strlen(buf)-1) = '\0';

	/* 行末の空白を削除 */
	/* 空白だけからなるデータへの対応が必要! */
	while(' ' == *(buf+strlen(buf)-1)) *(buf+strlen(buf)-1) = '\0';

	return;
}


/* yuniq 処理を行う */ 
char *edit(char *buf)
{
	char wbuf[BUFMAX],rbuf[BUFMAX]; /* 要BOF対策! */
	char old[100],new[100];
	char *p,*q,*r;

	/* 作業領域の初期化 */
	p = wbuf; strcpy(p,buf);
	r = rbuf; *r = '\0';
	*old = *new = '\0';

	/* 各フィールドを切り出す */
	while(NULL != (q = strtok(p," "))) {

		/* 前後のフィールドの受渡し */
		strcpy(old,new);
		strcpy(new,q);

		/* 前のフィールドと異なっていたら連結 */
		if(NULL != strcmp(old,new))   {
			strcat(r,new); strncat(r," ",1);
		}

		p = NULL;
	}

	/* 最後の空白を削除する */
	*(r+strlen(r)-1) = '\0';

	return r;
} 

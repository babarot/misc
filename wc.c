#include <stdio.h>
#include <stdlib.h>

void usage(char* cmd);
int wc(char* ifile);

int main(int argc, char* argv[])
{
	if ( argc == 1 ) usage(argv[0]);
	printf("[%s] has %d lines\n", argv[1], wc(argv[1]));
	return 0;
}
void usage(char* cmd)
{
	fprintf(stderr,"USAGE: %s <file>\n", cmd);
	exit(0);
}

int wc(char* ifile)
{
	FILE *fp;
	char buf[BUFSIZ];
	int n_line = 0;
	if ( (fp=fopen(ifile, "r")) == NULL ) {
		printf("%s: cannot open the file\n", ifile);
		return 0;
	}
	while ( fgets(buf, BUFSIZ, fp) ) n_line++;
	fclose(fp);
	return n_line;
}

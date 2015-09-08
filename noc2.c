#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>

char* do_noc(int minus, int *count) {
	static char date[80];

	time_t timer;
	struct tm *t_st;
	time(&timer);
	timer -= (86400 * minus);
	t_st = localtime(&timer);
	sprintf(date, "%d-%02d-%02d", t_st->tm_year + 1900, t_st->tm_mon + 1, t_st->tm_mday);

	char buf[255];
	FILE *fp;
	char *p;
	int  c = 0;

	char home[64];
	strcpy(home, getenv("HOME"));
	char path[128];
	sprintf(path, "%s/.bash_myhistory", home);

	if ((fp = fopen(path, "r")) == NULL) {
		fprintf(stderr, "Cannot open %s\n", path);
		exit(EXIT_FAILURE);
	}

	while (fgets(buf, 255, fp))
		if ((p = strstr(buf, date)) != NULL) *count = c++ + 1;

	if (ferror(fp)) {
		fprintf(stderr, "Error!\n");
		fclose(fp);
		exit(EXIT_FAILURE);
	}

	fclose(fp);
	return date;
}

int main(int argc, char *argv[])
{
	char *gomi;
	int c, i, larg = 9;
	int count = 0;
	opterr = 0;

	while ((c = getopt(argc, argv, "hl")) != -1) {
		switch (c) {
			default:
			case 'h':
				fprintf(stderr, "usage: %s [-h|-l] [NUM]\n", argv[0]);
				fprintf(stderr, "       -h    display this help and exit\n");
				fprintf(stderr, "       -l    display most recently used list\n");
				exit(EXIT_FAILURE);
			case 'l':
				if (argc > 2)
					larg = atoi(argv[2]);
				for (i = 0; i <= larg; i++)
					fprintf(stdout, "%d\t%s\t%d\n", i, do_noc(i, &count), count);
				exit(EXIT_SUCCESS);
		}
	}

	if (argc > 1)
		gomi = do_noc(atoi(argv[1]), &count);
	else
		gomi = do_noc(0, &count);

	fprintf(stdout, "%d\n", count);

	return 0;
}

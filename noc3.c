#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <ctype.h>

char *date(int minus);
int do_noc(int num);

int main(int argc, char *argv[])
{
	int  i, opt, l_arg = 9;
	opterr = 0;

	while ((opt = getopt(argc, argv, "hl")) != -1) {
		switch (opt) {
			default:
			case 'h':
				fprintf(stderr, "usage: %s [-h|-l] [NUM]\n", argv[0]);
				fprintf(stderr, "       -h    display this help and exit\n");
				fprintf(stderr, "       -l    display most recently used list\n");
				exit(EXIT_FAILURE);
			case 'l':
				if (argc > 2)
					l_arg = atoi(argv[2]);
				for (i = 0; i <= l_arg; i++)
					fprintf(stdout, "%d\t%s\t%d\n", i, date(i), do_noc(i));
				exit(EXIT_SUCCESS);
		}
	}

	if (argc == 1) printf("%d\n", do_noc(0));
	else           printf("%d\n", do_noc(atoi(argv[1])));

	return EXIT_SUCCESS;
}

int do_noc(int num) {
	char buf[255], *sp;
	FILE *fp;

	char path[128];
	sprintf(path, "%s/.bash_myhistory", getenv("HOME"));

	if ((fp = fopen(path, "r")) == NULL) {
		fprintf(stderr, "Cannot open %s\n", path);
		abort();
	}

	int count = 0;
	while (fgets(buf, sizeof buf, fp))
		if ((sp = strstr(buf, date(num))) != NULL) count++;

	if (ferror(fp)) {
		fprintf(stderr, "Error!\n");
		fclose(fp);
		abort();
	}

	fclose(fp);
	return count;
}

char *date(int minus) {
	char *buff;
	buff = (char *)malloc(120);

	time_t timer;
	struct tm *t_st;
	time(&timer);
	timer -= (86400 * minus);
	t_st = localtime(&timer);
	sprintf(buff, "%d-%02d-%02d", t_st->tm_year + 1900, t_st->tm_mon + 1, t_st->tm_mday);

	free(buff);
	return buff;
}

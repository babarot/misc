#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <ctype.h>

int do_noc(int minus, char *given)
{
	time_t timer;
	struct tm *t_st;
	time(&timer);
	timer -= (86400 * minus);
	t_st = localtime(&timer);
	sprintf(given, "%d-%02d-%02d", t_st->tm_year + 1900, t_st->tm_mon + 1, t_st->tm_mday);

	char buf[255], *p;
	FILE *fp;
	int  count = 0;

	char home[64];
	strcpy(home, getenv("HOME"));
	char path[128];
	sprintf(path, "%s/.bash_myhistory", home);

	if ((fp = fopen(path, "r")) == NULL) {
		fprintf(stderr, "Cannot open %s\n", path);
		abort();
	}

	while (fgets(buf, sizeof buf, fp))
		if ((p = strstr(buf, given)) != NULL) count++;

	if (ferror(fp)) {
		fprintf(stderr, "Error!\n");
		fclose(fp);
		abort();
	}

	fclose(fp);
	return count;
}

int main(int argc, char *argv[])
{
	int  i, opt, l_arg = 9;
	char *date;
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
					fprintf(stdout, "%d\t%s\t%d\n", i, &date, do_noc(i, &date));
				exit(EXIT_SUCCESS);
		}
	}

	if (argc > 1) {
		if (strcmp(argv[1], "0") == 0)
			fprintf(stdout, "%d\n", do_noc(atoi(argv[1]), &date));
		else if (atoi(argv[1]) == 0)
			exit(EXIT_SUCCESS);
		else
			fprintf(stdout, "%d\n", do_noc(atoi(argv[1]), &date));
	}
	else
		fprintf(stdout, "%d\n", do_noc(0, &date));

	return EXIT_SUCCESS;
}

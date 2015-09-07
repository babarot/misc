BEGIN  {
    for (i = 1; i < ARGC; ++i)
        printf("%s%s", ARGV[i], i == ARGC-1 ? "\n" : " ")
}

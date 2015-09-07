BEGIN {
    sort_exe = "sort -t \"\034\" -nr"
}

{
    printf("%d\034%s\n", NR, $0) |& sort_exe;
}

END {
    close(sort_exe, "to");

    while ((sort_exe |& getline var) > 0) {
        split(var, arr, /\034/);

        print arr[2];
    }
    close(sort_exe);
}

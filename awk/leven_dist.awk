BEGIN {
    fname1 = "doc1.txt";
    fname2 = "doc2.txt";
}

FILENAME == fname1 {
    for ( k = 1; k <= NF; k++ ) { arr1[n1++] = $k; }
}

FILENAME == fname2 {
    for ( k = 1; k <= NF; k++ ) { arr2[n2++] = $k; }
}

END {
    print n1 ", " n2 " : " leven(arr1, arr2)
}

function leven(arr1, arr2, tab, k1, k2) {
    len1 = length(arr1);
    len2 = length(arr2);
    for ( k1 = 0; k1 <= len1; k1++ ) { tab[k1][0] = k1; }
    for ( k2 = 0; k2 <= len2; k2++ ) { tab[0][k2] = k2; }
    for ( k1 = 1; k1 <= len1; k1++ ) {
        for ( k2 = 1; k2 <= len2; k2++ ) {
            v0 = tab[k1-1][k2-1];
            v1 = tab[k1  ][k2-1];
            v2 = tab[k1-1][k2  ];
            tab[k1][k2] = v0;
            if ( arr1[k1] == arr2[k2]) { continue; }
            if ( v0 > v1 ) { tab[k1][k2] = v1; }
            if ( v0 > v2 ) { tab[k1][k2] = v2; }
            tab[k1][k2]++;
        }
    }
    return tab[len1][len2];
}

function str_arr(str, arr, len, k) {
    len = length(str);
    for ( k = 0; k < len; k++ ) {
        arr[k] = substr(str, k, 1);
    }
}

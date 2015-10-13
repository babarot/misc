#!/usr/bin/env perl

use strict;
use warnings;
use File::Which;
use File::Which qw(which where);

sub para() {
    my ($argv) = @_;
    foreach (@$argv) {
        print `pygmentize $_`
    }
}

sub main() {
    my @argv = ();
    foreach my $arg (@ARGV) {
        if (-f $arg) {
            push(@argv, $arg) unless (grep {$_ eq $arg} @argv);
        }
    }

    &para(\@argv);
}

main

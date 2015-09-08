#! /usr/bin/perl
# -*- mode:perl; coding:utf-8 -*-
#
# append-header.pl -
#
# Copyright(C) 2009 by mzp
# Author: MIZUNO Hiroki / mzpppp at gmail dot com
# http://howdyworld.org
#
# Timestamp: 2009/03/10 21:20:38
#
# This program is free software; you can redistribute it and/or
# modify it under MIT Lincence.
#

use strict;
use warnings;
use Data::Dumper;

sub appendHeader($$) {
		    my ($header,$path) = @_;
    open(my $fh,'+<',$path);
    my @orig = <$fh>;

    seek  $fh,0,0;
    print $fh $header;
    print $fh @orig;
    close $fh;
}

my $header = join("",<STDIN>);

foreach my $path (@ARGV){
    appendHeader $header,$path;
}

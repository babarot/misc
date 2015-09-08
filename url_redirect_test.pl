#!/usr/bin/perl

use strict;
use LWP::UserAgent;
use Data::Dumper;

my $url = 'http://dot.b4b4r07.com';
my $ua = LWP::UserAgent->new();
my $response = $ua->get($url);
my $uri = $response->request->uri;

my $redirect = 'https://raw.github.com/b4b4r07/dotfiles/master/etc/install';
exit(1) unless $uri eq $redirect;

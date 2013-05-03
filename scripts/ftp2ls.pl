#!/usr/bin/env perl
use strict;
use warnings;

my $curdir = "";

while(<>){
    if(/^([^:]+):\s/){
        $curdir = $1."/";
        next;
    }

    if(/^((?:[^\s]+\s+){8})(.*)/){
        next if $2 =~ /^\./;
        next if $1 =~ /^d/;
        print "$1 $curdir$2 \n";
    }
}


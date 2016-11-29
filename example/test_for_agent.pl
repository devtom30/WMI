#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';


use Win32;


my $computer = $ARGV[2];
my $user = $ARGV[0];
my $pass = $ARGV[1];

my $service = Win32::_connectToService(
    $computer,
    $user,
    $pass,
    "root\\default"
);
if ($service) {
    print 'service ok ';
} else {
    print 'sa race';
}
print "\n";

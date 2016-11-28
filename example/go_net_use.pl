#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use Win32::TieRegistry(Delimiter => "/", ArrayValues => 0);
use Win32::Lanman;

$host = $ARGV[2];
$pass = $ARGV[1];
$user = $ARGV[0];
$domain = "";

if(!Win32::Lanman::NetUseAdd({remote => "\\\\$host\\ipc\$",
        password => "$pass",
        username => "$user",
        domain => "$domain",
        asg_type => &USE_IPC}))
{
    print "connect: Sorry, something went wrong; error: ";
    # get the error code
    print Win32::Lanman::GetLastError();
    exit 1;
}

$remoteKey = $Registry->{
    "//$host/LMachine/SOFTWARE/Microsoft/Windows NT/Curre
+ntVersion/ProductName"} or die "Can't read from $host. Error: $^E\n";
print "$remoteKey\n";

if(!Win32::Lanman::NetUseDel("\\\\$host\\ipc\$"))
{
    print "disconnect: Sorry, something went wrong; error: ";
    # get the error code
    print Win32::Lanman::GetLastError();
    exit 1;
}
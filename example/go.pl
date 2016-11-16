#!/usr/bin/perl -W

use strict;

use DMTF::WSMan;

my $user = $ARGV[0];
my $password = $ARGV[1];
my $host = $ARGV[2];
my $port = $ARGV[3];
my $wsman = DMTF::WSMan->new(
    user=>$user, 
    pass=>$password, 
    port=>$port, 
    protocol=>'http', 
    host=>$host
) or print 'pas glop';

# my $uri = "http://schemas.microsoft.com/wbem/wsman/1/" . "wmi/root/cimv2/Win32_Service?Name=winrm"; 
# my $uri = "http://schemas.microsoft.com/wbem/wsman/1/wmi/root/cimv2/Win32_Service";
my $uri = "http://schemas.microsoft.com/wbem/wsman/1/wmi/root/cimv2/Win32_Service";
my $xml = $wsman->get( 
    epr=>{
	ResourceURI=>$uri
    }
);
print $xml;
print "\n";
print "\n";
print "\n";

$xml = $wsman->enumerate(
    epr=>{
	ResourceURI=>$uri
    },
    filter => '*'
    );
print $xml;
open O, ">" . 'response.xml';
print O $xml

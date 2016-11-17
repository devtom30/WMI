#!/usr/bin/perl -W

use strict;
use lib '../lib';

use DMTF::WSMan;
use SOAP::Lite;
use Data::Dumper;
use XML::Parser;


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
# print $xml;
open O, ">" . 'response.xml';
print O $xml;

my $xmls = extractXmlFromResponse($xml);
$xml = $xmls->[0];

open O2, ">" . 'debug.log';
my $parser = XML::Parser->new(Style => 'Debug');
print O2 'On parse NOW' . "\n";
my $ret = $parser->parse($xml);
if ($ret) {
    print O2 "Yes, ça parse, c'est good" . "\n";
} else {
    print O2 "C'est PAS good, voici le retour :" . "\n";
    print O2 $ret;
}

my $deserial = SOAP::Deserializer->new;
my $obj = $deserial->deserialize($xml);
my $dd = Data::Dumper->new([$obj]);
print $dd->Dump;

sub extractXmlFromResponse {
    my ($response) = @_;

    my $xmls = [];
    my @split = split /</, $response;
    my $xml = '';
    my $line;
    while ($line = shift @split) {
	$xml .= $line;
	if ($line =~ /\/s:Envelope>/) {
	    push @$xmls, $xml;
	    $xml = '';
	}
    }

    return $xmls;
}

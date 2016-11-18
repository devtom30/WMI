#!/usr/bin/perl -W

use strict;
use lib '../lib';

use DMTF::WSMan;
use SOAP::Lite;
use Data::Dumper;
use XML::Parser;
use Tools;


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

my $xmls = Tools::extractXmlFromResponse($xml);
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
print 'ref : ' . ref $obj;
print "\n";

my $body = $obj->body;
$dd = Data::Dumper->new([$body]);
print $dd->Dump;
print 'ref : ' . ref $body;
print "\n";

if (2 == 1) {
my $enumerateResponse = $obj->dataof('//EnumerateResponse');
$dd = Data::Dumper->new([$enumerateResponse]);
print $dd->Dump;
print 'ref : ' . ref $enumerateResponse;
print "\n";

    my @items = $obj->dataof( '//EnumerateResponse/Items/Item' );
    for my $item (@items) {
        print 'item : ';
        print $item->name();
        print "\n";
        next;
        $dd = Data::Dumper->new( [ $item ] );
        print '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'."\n";
        print $dd->Dump;
        print '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<'."\n";
        print 'ref item : '.ref $item;
        print "\n";
    }
}

#my @items = $obj->valueof('//EnumerateResponse/Items/Item');
my $item;
for $item ($obj->valueof('//EnumerateResponse/Items/Item')) {
    print 'item : ';

    my $data = $item->{Win32_Service};
    my %data = %$data;

    my @filtered_keys = (
        'Name',
        'DisplayName',
        'SystemName',
        'Description',
        'Started',
        'State'
    );

    my %filtered_hash;
    @filtered_keys = grep { exists $data{$_} } @filtered_keys;
    @filtered_hash{@filtered_keys} = @data{@filtered_keys};
    $dd = Data::Dumper->new([\%filtered_hash]);
    print $dd->Dump;
}




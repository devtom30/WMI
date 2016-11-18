#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use Win32::OLE qw(in);
use Net::Ping;

use constant wbemFlagReturnImmediately => 0x10;
use constant wbemFlagForwardOnly => 0x20;

my $computer = $ARGV[2];

my $user = $ARGV[0];
my $pwd = $ARGV[1];


my $p = Net::Ping->new();
print "$computer is alive.\n" if $p->ping($host);
$p->close();

my $locatorObj = Win32::OLE->new("WbemScripting.SWbemLocator") or die "ERROR CREATING OBJ";

$locatorObj->{Security_}->{impersonationlevel} = 3;

my $objWMIService = $locatorObj->ConnectServer($computer, "root\\cimv2", $user, $pwd)
    or die "WMI connection failed.\n", Win32::OLE->LastError;

my $colItems = $objWMIService->ExecQuery("SELECT * FROM Win32_NTLogEvent", "WQL",
    wbemFlagReturnImmediately | wbemFlagForwardOnly);

foreach my $objItem (in $colItems) {
    print "Category: $objItem->{Category}\n";
    print "CategoryString: $objItem->{CategoryString}\n";
    print "ComputerName: $objItem->{ComputerName}\n";
    print "Data: " . join(",", (in $objItem->{Data})) . "\n";
    print "EventCode: $objItem->{EventCode}\n";
    print "EventIdentifier: $objItem->{EventIdentifier}\n";
    print "EventType: $objItem->{EventType}\n";
    print "InsertionStrings: " . join(",", (in $objItem->{InsertionStrings})) . "\n";
    print "Logfile: $objItem->{Logfile}\n";
    print "Message: $objItem->{Message}\n";
    print "RecordNumber: $objItem->{RecordNumber}\n";
    print "SourceName: $objItem->{SourceName}\n";
    print "TimeGenerated: $objItem->{TimeGenerated}\n";
    print "TimeWritten: $objItem->{TimeWritten}\n";
    print "Type: $objItem->{Type}\n";
    print "User: $objItem->{User}\n";
    print "\n";
}
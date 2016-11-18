package Tools;
use strict;
use warnings FATAL => 'all';

use DMTF::WSMan;
use SOAP::Lite;

sub extractXmlFromResponse {
    my ($response) = @_;

    my $xmls = [];
    my @split = split /</, $response;
    @split = grep /\w/, @split;
    my $xml = '';
    my $line;
    while ($line = shift @split) {
        $line = '<' . $line;
        $xml .= $line;
        if ($line =~ /\/s:Envelope>/) {
            push @$xmls, $xml;
            $xml = '';
        }
    }

    return $xmls;
}


sub createWSManConnection {
    my ($user, $password, $host, $port) = @_;

    my $wsman = DMTF::WSMan->new(
        user=>$user,
        pass=>$password,
        port=>$port,
        protocol=>'http',
        host=>$host
    );

    return $wsman;
}

sub retrieveURI {
    my ($wsmanConnection, $uri) = @_;

    my $res = $wsmanConnection->enumerate(
        epr=>{
            ResourceURI=>$uri
        }
    );

    return $res;
}

sub getEnumerateResponseObjectForURI {
    my ($wsmanConnection, $uri) = @_;

    my $xml = retrieveURI($wsmanConnection, $uri);
    my $xmls = extractXmlFromResponse($xml);
    my $xmlEnumerate = $xmls->[0];

    my $deserial = SOAP::Deserializer->new;
    my $obj = $deserial->deserialize($xmlEnumerate);

    return $obj;
}

sub filterHashIfKeysInList {
    my ($hashParam, @list) = @_;

    my %filteredHash;
    my %hash = %$hashParam;
    @list = grep { exists $hash{$_} } @list;
    @filteredHash{@list} = @hash{@list};

    return \%filteredHash;
}

1;

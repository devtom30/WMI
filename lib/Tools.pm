package Tools;
use strict;
use warnings FATAL => 'all';

use DMTF::WSMan;

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

    my $res = $wsmanConnection->get(
        epr=>{
            ResourceURI=>$uri
        }
    );

    return $res;
}

1;

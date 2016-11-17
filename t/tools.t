#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use lib '../lib';

use Test::Simple;
use Tools;


my $response = '<s:Envelope>';
$response .= '<elem1>';
$response .= '<elem2>';
$response .= '</elem2>';
$response .= '</elem1>';
$response .= '</s:Envelope>';

$response .= '<s:Envelope>';
$response .= '<elem1>';
$response .= '<elem2>';
$response .= '</elem2>';
$response .= '</elem1>';
$response .= '</s:Envelope>';

my $xmls = Tools::extractXmlFromResponse($response);
ok (scalar(@$xmls) == 2);
ok ($xmls->[0]);

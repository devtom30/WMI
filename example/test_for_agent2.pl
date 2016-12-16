#!\\usr\\bin\\perl
use strict;
use warnings FATAL => 'all';

use Win32::OLE qw/in/;
#$Win32::OLE::Warn = 3;
use Win32::OLE::Variant;
use Win32::Registry;
use Data::Dumper;
use Data::Structure::Util qw( unbless );

use TheWin32;

my $HKLM = 0x80000002;

my $computer = $ARGV[2];
my $user     = $ARGV[0];
my $pass     = $ARGV[1];

my $service =
  TheWin32::_connectToService( $computer, $user, $pass, "root\\default" );
if ( !$service ) {
    print 'sa race de service';
    exit;
}

Win32::OLE->Option(Warn => 3);

print 'service ok ';
print "\n";

my $objReg = $service->Get("StdRegProv");

my $hkey = $Win32::Registry::HKEY_LOCAL_MACHINE;

my $func2 = sub {
    print  'eval is fatal error !!!' . "\n";
};

my $return;
my $subKeys;
$subKeys = undef;
my $keyName = "SYSTEM\\CurrentControlSet\\Control\\Network\\{4D36E972-E325-11CE-BFC1-08002BE10318}";
eval {
    my $arr1 = Win32::OLE::Variant->new( Win32::OLE::Variant::VT_ARRAY() | Win32::OLE::Variant::VT_VARIANT() | Win32::OLE::Variant::VT_BYREF()  , [1,1] );
    my $arr2 = Win32::OLE::Variant->new( Win32::OLE::Variant::VT_ARRAY() | Win32::OLE::Variant::VT_VARIANT() | Win32::OLE::Variant::VT_BYREF()  , [1,1] );
    $return = $objReg->EnumValues($hkey, $keyName, $arr1, $arr2);
    #    my $err = sprintf(Win32::OLE->LastError);
    #    print '$err ' . $err . "\n";
    if ( Win32::OLE->LastError() ) {
        print Win32::OLE->LastError(), "\n";
    }
    if (0 && defined $return && $return == 0) {
        print 'return : ' . $return . "\n";

        foreach my $item (in( $arr1->Value )) {
            next unless $item;
            $subKeys = [] unless defined $subKeys;
            push @$subKeys, $item;
        }
        push @$subKeys, 'types';
        foreach my $item (in( $arr2->Value )) {
            next unless $item;
            $subKeys = [] unless defined $subKeys;
            push @$subKeys, $item;
        }
    }
    print $return;
    print "\n";

};
&$func2 if $@;
my $dd = Data::Dumper->new([$subKeys]);
print $dd->Dump;
sleep 3;
print Win32::OLE->LastError;
sleep 3;
print Win32::OLE->LastError;

print 'EnumValues ' . $keyName . "\n";
print 'error message : ' . Win32::OLE->LastError();
print "\n";


my $func = sub {
    my $str = shift;
    print $str . "\n" if $str;
    print 'mouarf' . "\n";
};

eval {
    my $rrr = Win32::OLE::Variant->new(Win32::OLE::Variant::VT_BYREF()|Win32::OLE::Variant::VT_BSTR(),0);
    my $retretret = $objReg->GetStringValue($Win32::Registry::HKEY_LOCAL_MACHINE, "HARDWARE\\DESCRIPTION\\System\\CentralProcessor\\0",
        "ProcessorNameString", $rrr);
    print 'ProcessorNameString (unexisting keyName) : ' . $retretret . ' ' . sprintf($rrr) . "\n";
};
&$func if $@;
print 'GetStringValue error message : ' . Win32::OLE->LastError();
print "\n";





eval {
    my $arr1 = Win32::OLE::Variant->new( Win32::OLE::Variant::VT_ARRAY() | Win32::OLE::Variant::VT_VARIANT() | Win32::OLE::Variant::VT_BYREF()  , [1,1] );
    my $arr2 = Win32::OLE::Variant->new( Win32::OLE::Variant::VT_ARRAY() | Win32::OLE::Variant::VT_VARIANT() | Win32::OLE::Variant::VT_BYREF()  , [1,1] );

    my $retretret = $objReg->EnumValues($Win32::Registry::HKEY_LOCAL_MACHINE, "HARDWARE\\DESCRIPTION\\System\\CentralProcessor\\0",
        , $arr1, $arr2);
    foreach my $item (in( $arr1->Value )) {
        push @$subKeys, $item;
    }
};
&$func if $@;
$dd = Data::Dumper->new([$subKeys]);
print $dd->Dump;
print Win32::OLE->LastError;
print 'GetStringValue error message : ' . Win32::OLE->LastError();
print "\n";

$keyName = "SYSTEM\\CurrentControlSet\\Control\\Network\\{4D36E972-E325-11CE-BFC1-08002BE10318}";
#    open(O, ">" . 'debug_' . time());
#    print O 'avant eval' . "\n";
$subKeys = undef;
eval {
    my $arr = Win32::OLE::Variant->new( Win32::OLE::Variant::VT_ARRAY() | Win32::OLE::Variant::VT_VARIANT() | Win32::OLE::Variant::VT_BYREF()  , [1,1] );
    $return = $objReg->EnumKey($HKLM, $keyName, $arr);
    if (defined $return && $return == 0) {
        print 'return : ' . $return . "\n";
        foreach my $item (in( $arr->Value )) {
            next unless $item;
            $subKeys = [] unless defined $subKeys;
            push @$subKeys, $item;
        }
    }
    print $return;
    print "\n";
};
&$func2 if $@;
$dd = Data::Dumper->new([$subKeys]);
print $dd->Dump;
print Win32::OLE->LastError;
print 'EnumKey ' . $keyName . "\n";
print 'error message : ' . Win32::OLE->LastError();
print "\n";

$subKeys = undef;
eval {
    my $arr1 = Win32::OLE::Variant->new( Win32::OLE::Variant::VT_ARRAY() | Win32::OLE::Variant::VT_VARIANT() | Win32::OLE::Variant::VT_BYREF()  , [1,1] );
    my $arr2 = Win32::OLE::Variant->new( Win32::OLE::Variant::VT_ARRAY() | Win32::OLE::Variant::VT_VARIANT() | Win32::OLE::Variant::VT_BYREF()  , [1,1] );
    print 'ref arr1 : ' . ref $arr1 . "\n";
    print 'ref arr2 : ' . ref $arr2 . "\n";
    $return = $objReg->EnumValues($hkey, $keyName, $arr1, $arr2);
#    my $err = sprintf(Win32::OLE->LastError);
#    print '$err ' . $err . "\n";
    my $sprintfError = sprintf("%s", Win32::OLE->LastError);
    print 'sprintfError : ' . $sprintfError . "\n;";
    if (defined $return && $return == 0) {
        print 'return : ' . $return . "\n";

        foreach my $item (in( $arr1->Value )) {
            next unless $item;
            $subKeys = [] unless defined $subKeys;
            push @$subKeys, $item;
        }
        push @$subKeys, 'types';
        foreach my $item (in( $arr2->Value )) {
            next unless $item;
            $subKeys = [] unless defined $subKeys;
            push @$subKeys, $item;
        }
    }
    print $return;
    print "\n";

};
&$func2 if $@;
$dd = Data::Dumper->new([$subKeys]);
print $dd->Dump;
print Win32::OLE->LastError;
print 'EnumValues ' . $keyName . "\n";
print 'error message : ' . Win32::OLE->LastError();
print "\n";

$keyName = "SYSTEM\\CurrentControlSet\\Control\\Network\\{4D36E972-E325-11CE-BFC1-08002BE10318}\\Descriptions";
if (2==1) {
    #    open(O, ">" . 'debug_' . time());
    #    print O 'avant eval' . "\n";
    $subKeys = undef;
    eval {
        my $arr = Win32::OLE::Variant->new(
            Win32::OLE::Variant::VT_ARRAY() | Win32::OLE::Variant::VT_VARIANT() | Win32::OLE::Variant::VT_BYREF(),
            [ 1, 1 ] );
        $return = $objReg->EnumKey($hkey, $keyName, $arr);
        if (defined $return && $return == 0) {
            print 'return : '.$return."\n";
            foreach my $item (in( $arr->Value )) {
                #            next unless $item;
                $subKeys = [] unless defined $subKeys;
                push @$subKeys, "$item";
            }
        }
        print $return;
        print "\n";

    };
    &$func2 if $@;
    $dd = Data::Dumper->new([ $subKeys ]);
    print Win32::OLE->LastError;
    print 'EnumKey ' . $keyName . "\n";

    print $dd->Dump;
    print 'error message : '.Win32::OLE->LastError();
    print "\n";
}
$subKeys = undef;
eval {
    my $arr1 = Win32::OLE::Variant->new( Win32::OLE::Variant::VT_ARRAY() | Win32::OLE::Variant::VT_VARIANT() | Win32::OLE::Variant::VT_BYREF()  , [1,1] );
    my $arr2 = Win32::OLE::Variant->new( Win32::OLE::Variant::VT_ARRAY() | Win32::OLE::Variant::VT_VARIANT() | Win32::OLE::Variant::VT_BYREF()  , [1,1] );
    $return = $objReg->EnumValues($hkey, $keyName, $arr1, $arr2);
    if (defined $return && $return == 0) {
        print 'return : ' . $return . "\n";

        foreach my $item (in( $arr1->Value )) {
            next unless $item;
            $subKeys = [] unless defined $subKeys;
            push @$subKeys, $item;
        }
        push @$subKeys, 'types';
        foreach my $item (in( $arr2->Value )) {
            next unless $item;
            $subKeys = [] unless defined $subKeys;
            push @$subKeys, $item;
        }
    }
    print $return;
    print "\n";

};
&$func2 if $@;
$dd = Data::Dumper->new([$subKeys]);
print $dd->Dump;
print Win32::OLE->LastError;
print 'EnumValues ' . $keyName . "\n";
print 'error message : ' . Win32::OLE->LastError();
print "\n";

my $arr = Win32::OLE::Variant->new( Win32::OLE::Variant::VT_ARRAY() | Win32::OLE::Variant::VT_VARIANT() | Win32::OLE::Variant::VT_BYREF()  , [1,1] );
#my $arr = Variant( VT_ARRAY | VT_VARIANT | VT_BYREF  , [1,1] );

#my $sPath = "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall";
my $sPath = "SYSTEM\\CurrentControlSet\\Control\\Network";

# Do not use Die for this method
my $iRC = $objReg->EnumKey($HKLM,
    $sPath, $arr); # or die "Cannot fetch registry key :",
print Win32::OLE->LastError;

foreach my $item ( in( $arr->Value ) ) {
    print "$item \n";
} # end foreach


$keyName = "SYSTEM\\CurrentControlSet\\Control\\Network\\";
#    open(O, ">" . 'debug_' . time());
#    print O 'avant eval' . "\n";
$subKeys = undef;
eval {
    my $arr = Win32::OLE::Variant->new( Win32::OLE::Variant::VT_ARRAY() | Win32::OLE::Variant::VT_VARIANT() | Win32::OLE::Variant::VT_BYREF()  , [1,1] );
    $return = $objReg->EnumKey($hkey, $keyName, $arr);
    if (defined $return && $return == 0) {
        print 'return : ' . $return . "\n";

        foreach my $item (in( $arr->Value )) {
            #            next unless $item;
            $subKeys = [] unless defined $subKeys;
            push @$subKeys, "$item";
        }
    }
    print $return;
    print "\n";

};
&$func2 if $@;
$dd = Data::Dumper->new([$subKeys]);
print 'EnumKey' . $keyName . "\n";
print $dd->Dump;
print 'error message : ' . Win32::OLE->LastError();
print "\n";
$subKeys = undef;
eval {
    my $arr1 = Win32::OLE::Variant->new( Win32::OLE::Variant::VT_ARRAY() | Win32::OLE::Variant::VT_VARIANT() | Win32::OLE::Variant::VT_BYREF()  , [1,1] );
    my $arr2 = Win32::OLE::Variant->new( Win32::OLE::Variant::VT_ARRAY() | Win32::OLE::Variant::VT_VARIANT() | Win32::OLE::Variant::VT_BYREF()  , [1,1] );
    $return = $objReg->EnumValues($hkey, $keyName, $arr1, $arr2);
    if (defined $return && $return == 0 && $arr1 && $arr2) {
        print 'return : ' . $return . "\n";
#        $subKeys = [ ];
        foreach my $item (in( $arr1->Value )) {
            next unless $item;
            $subKeys = [] unless defined $subKeys;
            push @$subKeys, $item;
        }
    }
    print $return;
    print "\n";

};
&$func2 if $@;
$dd = Data::Dumper->new([$subKeys]);
print 'EnumValues ' . $keyName . "\n";
print $dd->Dump;
print 'error message : ' . Win32::OLE->LastError();
print "\n";

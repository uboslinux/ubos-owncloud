#!/usr/bin/perl
#
# Access the OwnCloud installation for the first time.
#

use strict;

use IndieBox::Utils;
use POSIX;

my $dir         = $config->getResolve( 'appconfig.apache2.dir' );
my $apacheUname = $config->getResolve( 'apache2.uname' );
my $apacheGname = $config->getResolve( 'apache2.gname' );
my $hostname    = $config->getResolve( 'site.hostname' );

if( 'install' eq $operation ) {
    # now we need to hit the installation ourselves, otherwise the first user gets admin access
    my $out;
    my $err;
    if( IndieBox::Utils::myexec( "cd $dir; sudo -u $apacheUname php index.php", undef, \$out, \$err ) != 0 ) {
        die( "Activating OwnCloud in $dir failed: out: $out\nerr: $err" );
    }

    # now replace 'localhost' in the generated config.php with the actual site hostname
    my $configFile = "$dir/config/config.php";
    if( -e $configFile ) {
        my $configContent = IndieBox::Utils::slurpFile( $configFile );

        $configContent =~ s!'localhost'!'$hostname'!;

        IndieBox::Utils::saveFile( $configFile, $configContent, 0640, $apacheUname, $apacheGname );
    }
}

1;

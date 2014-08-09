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

    # now replace 'localhost' in the 'trusted_domains' section of the
    # generated config.php with the actual site hostname
    my $configFile = "$dir/config/config.php";
    if( -e $configFile ) {
        my $configContent = IndieBox::Utils::slurpFile( $configFile );
IndieBox::Utils::saveFile( '/tmp/config.php', $configFile );

        $configContent =~ s!(\d+\s*=>\s*)'localhost'!$1'$hostname'!;

        IndieBox::Utils::saveFile( $configFile, $configContent, 0640, $apacheUname, $apacheGname );
    }
}
<?php
$CONFIG = array (
  'passwordsalt' => '46f66ce3a2cde45755f33c2dc56523',
  'trusted_domains' => 
  array (
    0 => 'owncloud-test',
  ),
  'datadirectory' => 'data',
  'dbtype' => 'mysql',
  'version' => '7.0.1.1',
  'dbname' => 'apasnnfzawthzxtn',
  'dbhost' => 'owncloud-test',
  'dbtableprefix' => '',
  'dbuser' => 'ZkeMzJw48XH9eON1',
  'dbpassword' => 'La0iaBi5BMXeCyog',
  'installed' => true,
  'instanceid' => 'ocbcefbe9445',
);

1;

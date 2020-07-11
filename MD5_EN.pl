#!/usr/local/bin/perl

#-----------------------------------------------------------------------------------------#
# Injection tool by VOİXSEC.BLOGSPOT.COM
# Code version: 2.0
# Function file: MD5 Encode
#-----------------------------------------------------------------------------------------#

print "Mode: MD5 Encode v".$version."\n\nString: ";
chomp($hash = <STDIN>);

print "\n\n".md5_hex($hash)."\n\n";

1;

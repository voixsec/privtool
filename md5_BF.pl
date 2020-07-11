#!/usr/local/bin/perl

#-----------------------------------------------------------------------------------------#
# Injection tool by VOİXSEC.BLOGSPOT.COM
# Code version: 2.0
# Function file: MD5 Brute force
#-----------------------------------------------------------------------------------------#

@passwords =  &get_list("brute/","passwords.txt");

print "Mode: MD5 Brute force v".$version."\n\nHash: ";
chomp($hash = <STDIN>);

while(!($hash =~ /[a-zA-Z0-9]{32}/))
{
	print "\nInvalid hash!\nHash: ";
	chomp($hash = <STDIN>);
}

print "\n";

for($i = 0; $i < @passwords; $i++)
{
	$passwords[$i] =~ s/[\r\n\s]/ /g;	
	$passwords[$i] =~ s/\s+$//; 
	
	if($hash eq md5_hex($passwords[$i]))
	{
		print "\n\nDecode!\n\n*".$hash." is ".$passwords[$i]."\n\n";
		$i = @passwords;
	}
	else
	{
		print $passwords[$i]." - False\n";
	}
}

1;

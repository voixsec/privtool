#-----------------------------------------------------------------------------------------#
# Injection tool by VOİXSEC.BLOGSPOT.COM
# Code version: 2.0
# Function file: Hex encode/decode
#-----------------------------------------------------------------------------------------#

print "Mode: Hex encoder/decoder v".$version."\n\nEncode string(y/n)?: ";
chomp($whatdo = <STDIN>);

print "\nHex/Ascii: ";
chomp($string = <STDIN>);
print "\n";

if($whatdo eq "y" || (!($whatdo eq "n") && !($whatdo eq "y")))
{
	&generalPrint("",1);
	print $string." : ".&ascii2hex($string)."\n";
}
else
{
	&generalPrint("",1);
	
	$string =~ s/0x//g;
	print $string." : ".&hex2ascii($string)."\n";
}

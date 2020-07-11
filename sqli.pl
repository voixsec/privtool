#!/usr/local/bin/perl

#-----------------------------------------------------------------------------------------#
# Injection tool by VOİXSEC.BLOGSPOT.COM
# Code version: 2.0
# Function file: Get about by web, Scan sql injection in the site
#-----------------------------------------------------------------------------------------#

print "Mode: SQL injection scanner v1.0\n\nTarget(Must end '/'): ";
chomp($target = <STDIN>);

print "Char inject: ";
chomp($inject = <STDIN>);

while($inject eq "")
{
	&generalPrint("Mode: SQL injection scanner v1.0\n\nTarget: ".$target, 1);
	
	print "\nInvalid choice!\nYour choice: ";
	chomp($inject = <STDIN>);
}

while($inject eq "")
{
	&generalPrint("Mode: SQL injection scanner v1.0\n\nTarget: ".$target, 1);
	
	print "\nInvalid choice!\nYour choice: ";
	chomp($inject = <STDIN>);
}

&generalPrint("Mode: SQL injection scanner v1.0\n\nTarget: ".$target."\nChar inject: ".$inject."\n\nResults:\n", 1);
&foundLinks();

print "\n";

sub foundLinks()
{
	@links = ();
	
	$htm = &ghs($target);
	
	while($htm =~ m/\/*([\w\d\_]+\.php)((\?|\&)[\w\d]+\=([\d]+)+)/)
	{
		$link = $1;
		$get  = $2;
		$str_inj = $inject;
		
		print $target.$link.$get." - ";
		
		if(!in_array(\@links, $link))
		{
			$count = @links;
			
			$links['files'][$count]  = $link;
			$links['gets'][$count]   = $get;
							
			$a = &ghs($target.$link.$get, 1);
			
			$b = &ghs($target.$link.$get.$inject, 1);
			
			$str_inj = str_replace(' ', '%20', $str_inj);
			$b = str_replace($inject, '', $b);
			
			$str_inj = str_replace('%20', '%2520', $str_inj);
			$b = str_replace($str_inj, '', $b);
			
			$str_inj = str_replace('%2520', ' ', $str_inj);
			
			if(!($a eq $b))
			{
				print "Sql injection!";
				
				if($automatic)
				{
					$target = $target.$link.$get;
					
					&generalPrint("".$target,1);
					&firstChomp();
					&startInject();
					
					exit;
				}
			}
			else
			{
				print "Clean!";
			}
		}
			
		print "\n";
		
		$htm = str_replace($1, '' ,$htm);
		
	}	
}

1;

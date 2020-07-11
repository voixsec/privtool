#!/usr/local/bin/perl

#-----------------------------------------------------------------------------------------#
# Injection tool by VOİXSEC.BLOGSPOT.COM
# Code version: X
# Function file: General file/functions
#-----------------------------------------------------------------------------------------#

$localhost = "http://www.learnphp.co.il/yoni/tool.php";

&generalPrint("Find the newest version, please wait!",1);

$this_version = $version;
$new_version  = &ghs($localhost."?version=1");

if($this_version eq $new_version)
{
	&generalPrint("Last version: ".$new_version."\nYour version: ".$this_version."\n\nYou have the newest version!\n",1);
	print "Are you sure you want to update your software(y/n)?";
	chomp($asnw = <STDIN>);
}

if(!($this_version eq $new_version) || $asnw eq "y")
{
	$versions_info = "Last version: ".$new_version."\nYour version: ".$this_version."\n\n";
	&generalPrint($versions_info."Update files, please wait...\n",1);
	$total_files = &ghs($localhost."?show_file=1&total=1");
	
	&generalPrint("Files list:\n\n",1);
	
	for($i = 1; $i <= $total_files; $i++)
	{
		$file_path = &ghs($localhost."?show_file=1&about=1&id=".$i);
		
		$printer .= $file_path;
		&generalPrint($versions_info."Updating files...\n\n".$printer." - Get new source\n\n",1);
		
		if(!($file_path =~ m/^\.\/(((\/|)[a-z0-9]+\/)*)[a-z0-9\_]+\.pl$/i))
		{
			&generalPrint($versions_info."Updating files...\n\n".$printer." -Security error!\n\n",1);
			exit;
		}
		
		$file_source = &ghs($localhost."?show_file=1&source=1&id=".$i);

		if(open FILE, ">".$file_path)
		{
			print FILE $file_source;
			close FILE;
			$printer .= " - Updated\n";
			&generalPrint($versions_info."Updating files...\n\n".$printer,1);
		}
		else
		{
			&generalPrint($versions_info."Updating files...\n\n".$printer." -Error!\n\n",1);
			exit;
		}
	}
	$versions_info = "Last version: ".$new_version."\nYour version: ".$new_version."\n\n";
	&generalPrint("Last version: ".$new_version."\nYour version: ".$new_version."\n\nYou have the newest version!\n",1);
}
else
{
	&generalPrint("Last version: ".$new_version."\nYour version: ".$this_version."\n\nYou have the newest version!",1);
	exit;
}

exit;
1;

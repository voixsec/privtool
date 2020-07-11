import requests
import os
import sys
if os.name == "nt":
	os.system("cls")
	os.system("title ServerScan")
else:
	os.system("clear")
print("""
	##########################################
	#                                        #
	#        ServerScan Priv8 Exploit        #
	#         Hacking & Programming          #
	#                                        #
	##########################################
""")
type1 = 'type="password"'
try:
	urller = sys.argv[1]
	adminlist = sys.argv[2]
	bftimeout = sys.argv[3]
	kaydet = sys.argv[4]
	try:
		ac = open(urller, 'r').readlines()
		ac1 = open(adminlist, 'r').readlines()
		print(" [+] Tarama basladi!")
		print("")
	except:
		print("")
		print(" [-] Dosyalar bulunamadi!")
		sys.exit()
		print("")
	for url in ac:
		url = url.rstrip()
		for admin in ac1:
			admin = admin.rstrip()
			os.system("title " + "Taraniyor " + url + admin)
			try:
				r = requests.get(url + admin, timeout=float(bftimeout))
				if type1 in r.text:
					if "wp-submit" in r.text:
						print(url + admin + " [ WordPress ]")
						if kaydet == "E":
							with open("wordpress.txt","a") as f:
								f.write(url + "\n")
						else:
							pass
					elif "index.php?route=" in r.text:
						print(url + admin + " [ OpenCart ]")
						if kaydet == "E":
							with open("opencart.txt","a") as f:
								f.write(url + "\n")
						else:
							pass
					elif "joomla" in r.text:
						print(url + admin + " [ Joomla ]")
						if kaydet == "E":
							with open("joomla.txt","a") as f:
								f.write(url + "\n")
						else:
							pass
					else:
						print(url + admin)
						if kaydet == "E":
							with open("cikanlar.txt","a") as f:
								f.write(url + admin + "\n")
						else:
							pass
				else:
					pass
			except:
				break
	print("")
	print(" [+] Tarama bitti!")
except:
	print(" [!] Kullanim sekli ---> python serverscan.py sitelist.txt adminlist.txt 100 E")
	sys.exit()
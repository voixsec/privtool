import requests
import pyautogui
import time
import os
import sys

print("http(s) koymayı unutma")
url=input("URL'yi giriniz...:")
print("başladı")
r=requests.get(url)
a=r.text
while True:
    z=requests.get(url)
    x=z.text
    if x==a:
        pass
    else:
        print("çabuk gel")
        pyautogui.alert("ÇABUK GEL")
        time.sleep(2)
        os.system("python txtkonrol.py")
        sys.exit()
        
        

import json
import sys
import time

# Nouveau fichier decp.json (du jour)
newFile = sys.argv[1]
print('nouveau decp.json:', newFile)

debut = time.time()

listIdFile = open('todayMarches', encoding='utf8')
content = listIdFile.read().splitlines()
f = open(newFile, encoding='utf8')
marches = json.load(f)
outF = open("temp.json", "w", encoding='utf8')

newMarches = {"marches" :[]}
for marche in marches['marches']:
    if str(marche['uid']) in content:
        newMarches['marches'].append(marche)

outF.write(json.dumps(newMarches,ensure_ascii=False, indent=4, sort_keys=True))
temps_ecoule = time.time() - debut
print("Temps de traitement en secondes", int(temps_ecoule))
outF.close()
f.close()

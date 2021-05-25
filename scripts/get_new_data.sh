#!/bin/bash

#**********************************************************************
#
# Extrait les marchés ajoutés par rapport à fichier agrégé ancien
#
#**********************************************************************

oldFile=$1
newFile=$2

echo "Extraction des UID des anciens et nouveaux marchés, en remplaçant les espaces éventuels par 'xSPACEx'... "

jq -r '.marches[].uid' $oldFile | sed 's/ /xSPACEx/g' > oldMarchesRaw
jq -r '.marches[].uid' $newFile | sed 's/ /xSPACEx/g' > newMarchesRaw

nbMarchesRaw=`cat newMarchesRaw | wc -l`

sort -u oldMarchesRaw > oldMarchesNoDuplicates
sort -u newMarchesRaw > newMarchesNoDuplicates

nbMarchesUniqueOld=`cat oldMarchesNoDuplicates | wc -l`
nbMarchesUniqueNew=`cat newMarchesNoDuplicates | wc -l`

diff -u --suppress-common-lines oldMarchesNoDuplicates newMarchesNoDuplicates | grep -e "^+\w" | sed -E 's/^\+//' | sort -u > todayMarches

nbNewMarches=`cat todayMarches | wc -l`

echo -e "\
Ancien fichier :        $nbMarchesUniqueOld marchés uniques (via uid)\n
Nouveau fichier :       $nbMarchesUniqueNew marchés uniques\n
                        $nbNewMarches nouveaux marchés uniques\n"

#generation du fichier du jour dans le fichier temp.json
python3.7 scripts/python/generateDailyDecp.py $newFile

echo "Nombre de marchés dans le fichier des nouveaux marchés :"
jq '.marches | length' temp.json

date=`date "+%F"`
jq . temp.json > results/decp_$date.json

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

# Bizarrement,la différence de nombre de ligne entre oldMarchesNoDuplicates et newMarchesNoDuplicates n'est pas équivalente au nombre de marchés dans todaysMarches
# nbNewMarches=$(( $nbMarchesUniqueNew-$nbMarchesUniqueOld))

echo -e "\
Ancien fichier :        $nbMarchesUniqueOld marchés uniques (via uid)\n
Nouveau fichier :       $nbMarchesUniqueNew marchés uniques\n
                        $nbNewMarches nouveaux marchés uniques\n
                        $nbDuplicates doublons"

echo ""
echo "Diff entre la liste d'UID des anciens marchés et des nouveaux marchés..."



echo '{"marches":[' > temp.json

echo "Pour chaque nouvelle UID, export de l'objet marché correspondant vers un nouveau fichier..."
echo ""

i=1

for uid in `cat todayMarches`
do
         uid=`echo $uid | sed 's/xSPACEx/ /g'`
         echo "$i   $uid"
         if [[ $i -lt $nbNewMarches ]]
         then
             object=`jq --arg uid "$uid" '.marches[] | select(.uid == $uid)' $newFile | sed 's/^\}/},/'`
             ((i++));
         else
             object=`jq --arg uid "$uid" '.marches[] | select(.uid == $uid)' $newFile`
         fi
         echo "${object}" >> temp.json

done

echo ']}' >> temp.json

echo "Nombre de marchés dans le fichier des nouveaux marchés :"
jq '.marches | length' temp.json

date=`date "+%F"`
jq . temp.json > decp_$date.json

# rm oldMarchesNoDuplicates newMarchesNoDuplicates oldMarchesRaw newMarchesRaw todayMarches temp.json

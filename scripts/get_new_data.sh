#!/bin/bash

#**********************************************************************
#
# Extrait les marchés ajoutés par rapport à fichier agrégé ancien
#
#**********************************************************************

old=$1
new=$2

echo "Extraction des UID des anciens et nouveaux marchés, en remplaçant les espaces éventuels par 'xSPACEx'... "

jq -r '.marches[].uid' $old | sed 's/ /xSPACEx/' > oldMarchesRaw
jq -r '.marches[].uid' $new | sed 's/ /xSPACEx/' > newMarchesRaw

nbLinesRaw=`cat newMarchesRaw | wc -l`

sort -u oldMarchesRaw > oldMarches
sort -u newMarchesRaw > newMarches

nbLinesOld=`cat oldMarches | wc -l`
nbLinesNew=`cat newMarches | wc -l`
nbNew=$(( $nbLinesNew-$nbLinesOld ))
nbDoublons=$(( $nbLinesRaw-$nbLinesNew ))

echo -e "\
Ancien fichier :        $nbLinesOld marchés uniques (via uid)\n
Nouveau fichier :       $nbLinesNew marchés uniques\n
                        $nbNew nouveaux marchés uniques\n
                        $nbDoublons doublons"

echo ""
echo "Diff entre la liste d'UID des anciens marchés et des nouveaux marchés..."

diff -u --suppress-common-lines oldMarches newMarches | grep -e "^+\w" | sed -E 's/^\+//' > todayMarches

echo '{"marches":[' > temp.json

echo "Pour chaque nouvelle UID, export de l'objet marché correspondant vers un nouveau fichier..."
echo ""

i=1

for uid in `cat todayMarches`
do
         uid=`echo $uid | sed 's/xSPACEx/ /'`
         echo "$i   $uid"
         if [[ $i -lt $nbNew ]]
         then
             object=`jq --arg uid "$uid" '.marches[] | select(.uid == $uid)' $new | sed 's/^\}/},/'`
             ((i++));
         else
             object=`jq --arg uid "$uid" '.marches[] | select(.uid == $uid)' $new`
         fi
         echo "${object}" >> temp.json

done

echo ']}' >> temp.json

tail -n 50 temp.json

echo "Nombre de marchés dans le fichier des nouveaux marchés :"
jq '.marches | length' temp.json

date=`date "+%F"`
jq . temp.json > decp_$date.json

rm oldMarches newMarches oldMarchesRaw newMarchesRaw todayMarches temp.json

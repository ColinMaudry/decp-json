#/bin/bash

# Dans les rapports d'erreur du validateurs OCDS (https://standard.open-contracting.org) les erreurs utilisent toujours l'index de la release dans l'array général.
#
# Afin de récupérer le marché correspondant et diagnostiquer le problème, ce script
#
# 1. prend un index d'array en entrée
# 2. va chercher la release OCDS qui correspond dans json/decp.ocds.json (ce doit être le fichier qui a été traité par le validateur)
# 3. récupère le decpUID dans cette release
# 4. va chercher le marché DECP pour cette UID dans json/decp.json
#
# La release OCDS et le marché DECP sont affichés pour diagnostic

releaseIndex=$1

ocds=`jq --arg index $releaseIndex '($index | tonumber) as $indexNum | .releases[$indexNum]' json/decp.ocds.json`

releaseId=`echo $ocds | jq -r '.id'`
uid=`echo $ocds | jq -r '.decpUID'`

echo "Release ID: $releaseId"
echo "DECP UID: $uid"
echo ""
echo "=== OCDS ===="
echo ""

echo $ocds | jq .

echo ""
echo "=== DECP ===="
echo ""

jq --arg uid $uid '.marches[] | select(.uid == ($uid))' json/decp.json

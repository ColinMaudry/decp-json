#!/bin/bash

#**********************************************************************
#
# Aggrégation du JSON de toutes les sources
#
#**********************************************************************

echo "## Agrégation du JSON de toutes les sources"
cd ./json

# Suppression de l'ancien fichier agrégé
if [[ -f decp.json ]]
then
    rm decp.json
fi

# Fusion des JSON de toutes les sources
../scripts/mergeJson.sh > decp_with_duplicates.json

nombreMarches=`jq '.marches | length' decp_with_duplicates.json`

echo ""
echo "Le fichier consolidé contient $nombreMarches marchés avant déduplication."
echo ""

jq '{"marches": .marches | unique_by(.uid)}' decp_with_duplicates.json > decp.json
rm decp_with_duplicates.json

nombreMarchesNoDuplicates=`jq '.marches | length' decp.json`


echo ""
echo "Le fichier consolidé contient $nombreMarchesNoDuplicates marchés après déduplication."
echo "Il contenait donc $((nombreMarches-nombreMarchesNoDuplicates)) doublons."
echo ""

# Création d'une archive ZIP avec tous les JSON de la source choisie
date=`date +%Y-%m-%d`
if [[ ! -d archives ]]
then
    mkdir archives
fi
zip -q -9 archives/decp_$date.zip decp.json

ls -lh decp.json
ls -lh archives/decp_$date.zip

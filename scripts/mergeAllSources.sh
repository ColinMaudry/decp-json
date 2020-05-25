#!/bin/bash

#**********************************************************************
#
# Aggrégation du JSON de toutes les sources
#
#**********************************************************************


echo "## Agrégation du JSON de toutes les sources"

export DECP_HOME=`pwd`

cd ./json

# Suppression de l'ancien fichier agrégé
if [[ -f decp.json ]]
then
    rm decp.json
fi

# Fusion des JSON de toutes les sources
$DECP_HOME/scripts/mergeJson.sh > decp_with_duplicates.json

nombreMarches=`jq '.marches | length' decp_with_duplicates.json`

echo ""
echo "Le fichier consolidé contient $nombreMarches marchés avant déduplication."
echo ""

# Déduplication des marchés
jq '{"marches": .marches | unique_by(.uid)}' decp_with_duplicates.json > decp.json
rm decp_with_duplicates.json

nombreMarchesNoDuplicates=`jq '.marches | length' decp.json`

echo ""
echo "Le fichier consolidé contient $nombreMarchesNoDuplicates marchés après déduplication."
echo "Il contenait donc $((nombreMarches-nombreMarchesNoDuplicates)) doublons."
echo ""


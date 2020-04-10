#!/bin/bash

#**********************************************************************
#
# Transformation des données du format DECP JSON vers le format OCDS JSON
#
#**********************************************************************

# fail on error
set -e

# Récupération des variables injectées dans l'OCDS
source $DECP_HOME/scripts/jq/ocds/config.sh

$DECP_HOME/scripts/makeOCDS_json.sh $1 > $DECP_HOME/json/releases.ocds.json

if [[ $2 -eq "allFormats" ]]
then

# Création des fichiers tabulaires à partir des releases JSON

flatten-tool flatten json/releases.ocds.json --root-id=ocid --main-sheet-name releases --root-list-path=releases

mv flattened.xlsx flattened/

fi

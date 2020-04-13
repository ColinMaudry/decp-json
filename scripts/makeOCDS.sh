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

#!/bin/bash

#**********************************************************************
#
# Transformation des données du format DECP JSON vers le format OCDS JSON
#
#**********************************************************************

# fail on error
set -e

if [[ -z $datetime ]]
then
 export datetime=`date "+%FT%T+02:00"`
fi

export dataset_id="5d1a216e6f4441513e89b93e"
export package_uri="https://www.data.gouv.fr/fr/datasets/r/2a84ffc7-7121-48d2-a28f-85d835ed09a4"
export dataset_url="https://www.data.gouv.fr/fr/datasets/$dataset_id"
export ocid_prefix="ocds-78apv2"
export DECP_HOME=`pwd`

# Récupération des variables injectées dans l'OCDS
source $DECP_HOME/scripts/jq/ocds/config.sh

$DECP_HOME/scripts/makeOCDS_json.sh $1 > $DECP_HOME/json/releases.ocds.json

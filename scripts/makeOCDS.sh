#!/bin/bash

#**********************************************************************
#
# Transformation des données du format DECP JSON vers le format OCDS JSON
#
#**********************************************************************

# fail on error
set -e

if [ -z $datetime ]
then
    datetime=`date "+%FT%T+02:00"`
fi
dataset_id="5d1a216e6f4441513e89b93e"
package_uri="https://www.data.gouv.fr/fr/datasets/r/2a84ffc7-7121-48d2-a28f-85d835ed09a4"
dataset_url="https://www.data.gouv.fr/fr/datasets/$dataset_id"
ocid_prefix="ocds-78apv2"

# Création du fichier de release OCDS à partir des DECP

jq --arg datetime $datetime --arg datasetUrl $dataset_url --arg ocidPrefix $ocid_prefix --arg packageUri $package_uri -f scripts/jq/ocds/decp2ocds.jq $1 > json/releases.json

# Création des fichiers tabulaires à partir des releases JSON

flatten-tool flatten json/releases.json --root-id=ocid --main-sheet-name releases --root-list-path=releases

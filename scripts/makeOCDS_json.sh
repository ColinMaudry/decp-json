#!/bin/bash

#**********************************************************************
#
# Transformation des données du format DECP JSON vers le format OCDS JSON
#
#**********************************************************************

# fail on error
set -e

# Création du fichier de release OCDS à partir des DECP
jq -c -M --arg datetime $datetime --arg datasetUrl $dataset_url --arg ocidPrefix $ocid_prefix --arg packageUri $package_uri -f scripts/jq/ocds/decp2ocds.jq $1 \
  | sed 's/"[^"]*":\(null\|\[\]\|{}\),\?//g' | sed 's/,}/}/g' | jq '.'

#  L'usage du sed et du jq final ainsi que le -c dans le premier jq correspond au walk commenté dans le script scripts/jq/ocds/decp2ocds.jq
#  le walk étant très gourmand en mémoire, sur la CI, cela ne passe pas et nous n'avons pas la main pour augmenter les ressources

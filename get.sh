#!/bin/bash

#**********************************************************************
#
# Récupération des données pour une source ou pour toutes
#
#**********************************************************************

# Pour facilement s'y retrouver dans les répertoires, création d'une variable avec le chemin de la racine de decp-json
export DECP_HOME=`pwd`
source=$1

if [ -d ./scripts/sources/$source -a -f ./scripts/sources/$source/get.sh ]
    then

    # Si des données sont déjà présentes, on les supprime
    if [[ -d ./sources/$source ]]
        then
        rm -r ./sources/$source
    fi

    mkdir ./sources/$source
    cd ./sources/$source

    $DECP_HOME/scripts/sources/$source/get.sh $source

    ## Ajouter la date du dernier téléchargement dans les métadonnées

    metadata="$DECP_HOME/sources/metadata.json"

    jq --arg source $source -f $DECP_HOME/scripts/jq/addLastDownloadTime.jq $metadata > $metadata.temp
    mv $metadata.temp $metadata


elif [[ -z "$source" ]]
    then
    echo "Récupération de toutes les sources (désactivé)"
else
    sources=`ll ./scripts/sources`
    echo "Cette source n'existe pas"
    echo ""
    echo "Voici les sources supportées pour GET :"
    echo ""
    ls -1 scripts/sources
    echo ""

    exit 1
fi

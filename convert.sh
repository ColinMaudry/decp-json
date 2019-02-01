#!/bin/bash

#**********************************************************************
#
# Conversion des données vers le format JSON, pour une source ou pour toutes
#
#**********************************************************************

# Pour facilement s'y retrouver dans les répertoires, création d'une variable avec le chemin de la racine de decp-json
export DECP_HOME=`pwd`
source=$1

if [[ -d ./scripts/sources/$source ]]
    then
    cd ./scripts/sources/$source
    ./convert.sh $source
elif [[ -z "$source" ]]
    then
    echo "Conversion de toutes les sources téléchargées (désactivé pour l'instant)"
else
    echo "Cette source n'existe pas"
    echo ""
    echo "Voici les sources supportées pour CONVERT :"
    echo ""
    ls -1 scripts/sources
    echo ""

    exit 1
fi

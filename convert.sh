#!/bin/bash

#**********************************************************************
#
# Conversion des données vers le format JSON, pour une source ou pour toutes
#
#**********************************************************************

# Pour facilement s'y retrouver dans les répertoires, création d'une variable avec le chemin de la racine de decp-json
export DECP_HOME=`pwd`
source=$1

if [ -d ./scripts/sources/$source -a -f ./scripts/sources/$source/convert.sh ]
    then
    cd ./scripts/sources/$source
    ./convert.sh $source

# Si pas de fichier de conversion, mais des fichiers sources, alors pas besoin de conversion et copie directe vers JSON
elif [ -d ./scripts/sources/$source -a ! -f ./scripts/sources/$source/convert.sh -a "$(ls -A ./sources/$source)" ]
    then
        if [[ -d ./json/$source ]]
            then
            rm -r ./json/$source
        fi
        cp -r ./sources/$source ./json
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

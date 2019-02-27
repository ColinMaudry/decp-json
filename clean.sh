#!/bin/bash

#**********************************************************************
#
# Suppression des fichiers JSON convertis (faites un package avant !)
#
#**********************************************************************

# Pour facilement s'y retrouver dans les répertoires, création d'une variable avec le chemin de la racine de decp-json
export DECP_HOME=`pwd`
source=$1


if [[ -d ./json/$source ]]
    then

    # Suppression des données JSON pour la source choisie
    rm -rf ./json/$source
    rm ./json/*.json

elif [[ -z "$source" ]]
    then
    echo "Suppression des données JSON pour toutes les sources (désactivé)"
else
    cd ./json
    echo "Cette source n'existe pas"
    echo ""
    echo "Voici les sources supportées pour CLEAN :"
    echo ""
    ls -d1 */
    echo ""

    exit 1
fi

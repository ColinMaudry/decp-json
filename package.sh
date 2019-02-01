#!/bin/bash

#**********************************************************************
#
# Création d'une archive ZIP des données converties en JSON
#
#**********************************************************************

# Pour facilement s'y retrouver dans les répertoires, création d'une variable avec le chemin de la racine de decp-json
export DECP_HOME=`pwd`
source=$1
date=`date +%Y-%m-%d`


if [[ -d ./json/$source ]]
    then
    cd ./json
    filename=$source-json

    # Suppression de l'ancienne denière archive ZIP de la source choisie
    rm $filename.zip

    # Création d'une archive ZIP avec tous les JSON de la source choisie
    zip -q -9 $filename.zip $source/*.json
    cp $filename.zip ${filename}_$date.zip

elif [[ -z "$source" ]]
    then
    echo "Récupération de toutes les sources (désactivé)"
else
    cd ./json
    echo "Cette source n'existe pas"
    echo ""
    echo "Voici les sources supportées pour GET :"
    echo ""
    ls -d1 */
    echo ""

    exit 1
fi

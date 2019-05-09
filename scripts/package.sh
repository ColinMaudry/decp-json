#!/bin/bash

#**********************************************************************
#
# Création d'une archive ZIP des données converties en JSON
#
#**********************************************************************

source=$1
date=`date +%Y-%m-%d`


if [[ -d $DECP_HOME/json/$source ]]
    then

    echo "## Empaquetage ($source)..."

    cd $DECP_HOME/json/$source

    # Fusion de tous les fichiers en un seul et dans la foulée, ajoute le code de la source et l'ID unique dans le JSON
    $DECP_HOME/scripts/mergeJson.sh | $DECP_HOME/scripts/insertSourceUidInJSON.sh $source > ../$source.json

    filename=${source}_json

    cd $DECP_HOME/json

    if [[ ! -d archives ]]
    then
        mkdir archives
    fi
    # Création d'une archive ZIP avec tous les JSON de la source choisie
    zip -q -9 archives/${filename}_$date.zip ${source}.json

    if [[ -f archives/${filename}_$date.zip ]]
    then
        echo "Empaquetage de $source OK"
    fi
elif [[ -z "$source" ]]
    then
    echo "Il manque un code source en paramètre."
else
    cd ./json
    echo "Cette source n'existe pas"
    echo ""
    echo "Voici les sources supportées pour PACKAGE :"
    echo ""
    ls -d1 */
    echo ""

    exit 1
fi

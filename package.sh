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


if [[ -d $DECP_HOME/json/$source ]]
    then

    cd $DECP_HOME/json/$source

    # Fusion de tous les fichiers en un seul et dans la foulée, ajoute le code de la source dans le JSON
    $DECP_HOME/scripts/mergeJson.sh | $DECP_HOME/scripts/insertSourceInJSON.sh $source > ../$source.json

    filename=${source}_json

    cd $DECP_HOME/json

    # Suppression de l'ancienne denière archive ZIP de la source choisie
    if [[ -f $filename.zip ]]
    then
        rm $filename.zip
    fi

    # Création d'une archive ZIP avec tous les JSON de la source choisie
    zip -q -9 $filename.zip $source.json
    cp $filename.zip ${filename}_$date.zip

    # Suppression du fichier des JSON fusionnés
    # rm $source.json

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

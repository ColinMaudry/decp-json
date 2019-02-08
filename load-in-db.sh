#!/bin/bash

#**********************************************************************
#
# Chargement des données JSON dans une base de données
#
#**********************************************************************

# Pour facilement s'y retrouver dans les répertoires, création d'une variable avec le chemin de la racine de decp-json
export DECP_HOME=`pwd`
source=$1

if [[ -f $DECP_HOME/json/${source}_json.zip ]]
    then
    if [[ ! -r $DECP_HOME/config/config.sh ]]
    then
        echo "Vous devez faire un copie de /config/config_template.sh en /config/config.sh, et personnaliser son contenu. Fin du script."
        exit 1
    else
        source $DECP_HOME/config/config.sh
    fi

    unzip -o $DECP_HOME/json/${source}_json.zip

    jq '.marches' $source.json | mongoimport --username $mongoUsername --password $mongoPassword --host $mongoHost:$mongoPort --db $mongoDatabase --collection $mongoCollection --drop --jsonArray

    rm $source.json

elif [[ -z "$source" ]]
    then
    echo "Chargement de toutes les données JSON (désactivé pour l'instant)"
else
    cd ./json
    echo "Cette source n'existe pas"
    echo ""
    echo "Voici les sources supportées pour LOAD IN DB :"
    echo ""
    ls -d1 */
    echo ""

    exit 1
fi

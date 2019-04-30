#!/bin/bash

#**********************************************************************
#
# Suppression des fichiers JSON convertis (faites un package avant !)
#
#**********************************************************************

source=$1


if [[ -d $DECP_HOME/json/$source ]]
    then

    echo "## Suppression des fichiers JSON ($source)..."

    # Suppression des données JSON pour la source choisie
    rm -rf $DECP_HOME/json/$source
    rm ../json/*.json

elif [[ -z "$source" ]]
    then
    echo "Il manque le code d'une source en paramètre."
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

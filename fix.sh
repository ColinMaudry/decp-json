#!/bin/bash

#**********************************************************************
#
# Correction des anomalies dans les données source
#
#**********************************************************************

# Pour facilement s'y retrouver dans les répertoires, création d'une variable avec le chemin de la racine de decp-json
export DECP_HOME=`pwd`
source=$1

if [[ -d $DECP_HOME/sources/$source ]]
    then

    cd $DECP_HOME/sources/$source

    if [[ ! -d original-data ]]
    then
        mkdir original-data
        cp *.* original-data/
    fi

    rm *.*

    $DECP_HOME/scripts/sources/$source/fix.sh $source

elif [[ -z "$source" ]]
    then
    echo "Correction de toutes les sources (désactivé)"
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

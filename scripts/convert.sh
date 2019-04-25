#!/bin/bash

#**********************************************************************
#
# Conversion des données vers le format JSON, pour une source ou pour toutes
#
#**********************************************************************

# Pour facilement s'y retrouver dans les répertoires, création d'une variable avec le chemin de la racine de decp-json
export DECP_HOME=`pwd`
source=$1

if [ -d $DECP_HOME/scripts/sources/$source -a -f $DECP_HOME/scripts/sources/$source/convert.sh ]
    then
        echo "Conversion ($source)..."
    cd $DECP_HOME/scripts/sources/$source
    ./convert.sh $source

# Si pas de fichier de conversion, mais des fichiers sources, alors pas besoin de conversion et copie directe vers JSON
elif [ -d $DECP_HOME/scripts/sources/$source -a ! -f $DECP_HOME/scripts/sources/$source/convert.sh -a "$(ls -A $DECP_HOME/sources/$source)" ]
    then
        echo "Pas de conversion, copie des fichiers source vers /json/$source."
        if [[ -d $DECP_HOME/json/$source ]]
            then
            rm -r $DECP_HOME/json/$source
        fi
        cp -r $DECP_HOME/sources/$source $DECP_HOME/json
elif [[ -z "$source" ]]
    then
    echo "Il manque le code d'une source en paramètre."
else
    echo "Cette source n'existe pas"
    echo ""
    echo "Voici les sources supportées pour CONVERT :"
    echo ""
    ls -1 sources
    echo ""

    exit 1
fi

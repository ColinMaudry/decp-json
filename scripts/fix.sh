#!/bin/bash

#**********************************************************************
#
# Correction des anomalies dans les données source
#
#**********************************************************************

source=$1

if [ -d $DECP_HOME/sources/$source -a -f $DECP_HOME/scripts/sources/$source/fix.sh ]
    then

    cd $DECP_HOME/sources/$source

    $DECP_HOME/scripts/sources/$source/fix.sh $source

elif [ -d $DECP_HOME/sources/$source -a ! -f $DECP_HOME/scripts/sources/$source/fix.sh ]
        then
        echo "Pas de correction configurée pour cette source."
        exit 0

elif [[ -z "$source" ]]
    then
    echo "Il manque le code d'une source en paramètre."
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

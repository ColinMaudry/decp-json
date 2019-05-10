#!/bin/bash

#**********************************************************************
#
# Récupération des données pour une source ou pour toutes
#
#**********************************************************************

source=$1

if [ -d $DECP_HOME/scripts/sources/$source -a -f $DECP_HOME/scripts/sources/$source/get.sh ]
    then

    echo "## Téléchargement ($source)..."
    # Si des données sont déjà présentes, on les supprime
    if [[ -d $DECP_HOME/sources/$source ]]
        then
        rm -r $DECP_HOME/sources/$source
    fi

    mkdir $DECP_HOME/sources/$source
    cd $DECP_HOME/sources/$source

    $DECP_HOME/scripts/sources/$source/get.sh $source

elif [[ -z "$source" ]]
    then
    echo "Il manque le code d'une source en paramètre."
else
    echo "Cette source ($source) n'existe pas"
    echo ""

    exit 1
fi

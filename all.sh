#!/bin/bash

#**********************************************************************
#
# Toutes les opérations de récupération, correction, conversion et empaquetage pour la source sélectionnée.
#
#**********************************************************************

source=$1

if [[ -f ./config/config.sh ]]
then

source config/config.sh

## Téléchargement
./get.sh $source

## Correction
./fix.sh $source

## Conversion
./convert.sh $source

## Empaquetage
./package.sh $source
    if [[ ! -z $mongoUsername ]]
    then
        ## Chargement en base de données
        ./load-in-db.sh $source
    fi
else
    echo "Vous devez d'abord faire une copie de ./config/config_template.sh vers ./config/config.sh."
fi

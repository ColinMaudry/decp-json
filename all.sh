#!/bin/bash

#**********************************************************************
#
# Toutes les opérations de récupération, correction, conversion et empaquetage pour la source sélectionnée.
#
#**********************************************************************

source=$1

echo "## Téléchargement..."
./get.sh $source

echo "## Correction..."
./fix.sh $source

echo "## Conversion..."
./convert.sh $source

echo "## Empaquetage..."
./package.sh $source

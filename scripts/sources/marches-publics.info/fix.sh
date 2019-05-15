#!/bin/bash

# Correction des anomalies des données essentielles publiées par marches-publics.info

source=$1

echo ""

if [[ ! -d original-data ]]
then
    echo "Déplacement des fichiers téléchargés vers source/$source/original-data..."
    mkdir original-data
    mv *.* original-data/
else
    echo "Suppression des fichiers source/$source/original-data..."
    rm *.*
fi

echo "Correction des anomalies"

for file in `ls original-data`
do
    echo "Correction de $file..."
    jq -f $DECP_HOME/scripts/sources/$source/fix.jq ./original-data/$file > $file
done

if [[ ! -d $DECP_HOME/json/$source ]]
then
    mkdir $DECP_HOME/json/$source
fi

echo "Copie des fichiers corrigés vers json/$source..."

cp *.* $DECP_HOME/json/$source

#!/bin/bash

# Correction des anomalies des données essentielles publiées par marches-publics.info

source=$1

for file in `ls original-data`
do
    jq -f $DECP_HOME/scripts/sources/$source/fix.jq ./original-data/$file > $file
    validate-decp.sh $file
done

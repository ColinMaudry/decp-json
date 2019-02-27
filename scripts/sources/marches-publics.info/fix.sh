#!/bin/bash

# Correction des anomalies des données essentielles publiées par marches-publics.info

source=$1

if [[ ! -d original-data ]]
then
    mkdir original-data
    cp *.* original-data/
fi

rm *.*

for file in `ls original-data`
do
    jq -f $DECP_HOME/scripts/sources/$source/fix.jq ./original-data/$file > $file
    validate-decp.sh $file
done

mkdir $DECP_HOME/json/$source
cp *.* $DECP_HOME/json/$source

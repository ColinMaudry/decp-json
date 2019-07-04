#!/bin/bash

# Correction des anomalies des données essentielles publiées par l'AIFE


source=$1

if [[ ! -d original-data ]]
then
    mkdir original-data
    cp *.* original-data/
fi

rm *.*

for file in `ls original-data`
do
    date=`echo $file |  sed -r 's/donnees\-essentielles\-marches([0-9]{2})\.([0-9]{2})\.([0-9]{4}).*/\3-\2-\1/'`
    xsltproc --stringparam date "$date" $DECP_HOME/scripts/sources/$source/fix.xslt ./original-data/$file > $file
done

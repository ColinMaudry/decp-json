#!/bin/bash

# Ce script convertit les données de l'AIFE en DECP JSON

source=$1

cd $DECP_HOME/sources/$source

mkdir -p $DECP_HOME/json/$source

for xml in *.xml
do

#Converti le XML DECP vers JSON DECP
$DECP_HOME/scripts/xmlDECP2jsonDECP.sh $xml >  $DECP_HOME/json/$source/$xml.json
done

cd $DECP_HOME/json/$source

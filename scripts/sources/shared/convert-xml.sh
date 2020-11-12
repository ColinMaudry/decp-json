#!/bin/bash

source=$1

cd $DECP_HOME/sources/$source

mkdir -p $DECP_HOME/json/$source

for xml in `ls *.*`
do
  echo "$xml..."
  #Converti le XML DECP vers JSON DECP
  $DECP_HOME/scripts/xmlDECP2jsonDECP.sh $xml >  $DECP_HOME/json/$source/$xml.json
done

cd $DECP_HOME/json/$source

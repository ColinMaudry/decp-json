#!/bin/bash

#**********************************************************************
#
# Chargement des données JSON dans une base de données
#
#**********************************************************************

source config/config.sh


# Chargement des métadonnées des sources
curl -s https://raw.githubusercontent.com/etalab/decp-rama/master/sources/metadata.json > source-metadata.json

mongoimport --username $mongoUsername --password $mongoPassword --host $mongoHost:$mongoPort --db $mongoDatabase --collection sources --drop --jsonArray --file source-metadata.json

if [[ -s sourceStats.json ]]
then
    mongoimport --username $mongoUsername --password $mongoPassword --host $mongoHost:$mongoPort --db $mongoDatabase --collection stats --drop --jsonArray --file sourceStats.json
fi

# Chargement des données agrégées de decp-rama
curl -s https://www.data.gouv.fr/fr/datasets/r/16962018-5c31-4296-9454-5998585496d2 > decp.json

jq '.marches' decp.json | mongoimport --username $mongoUsername --password $mongoPassword --host $mongoHost:$mongoPort --db $mongoDatabase --collection data --drop --jsonArray

# Chargement des stats
jq '.' sourceStats.json | mongoimport --username $mongoUsername --password $mongoPassword --host $mongoHost:$mongoPort --db $mongoDatabase --collection stats --drop --jsonArray

mongo -u $mongoUsername -p $mongoPassword --eval 'db.data.createIndex({"$**":"text"},{"default_language":"french"})' $mongoDatabase

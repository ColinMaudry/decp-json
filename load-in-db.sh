#!/bin/bash

#**********************************************************************
#
# Chargement des données JSON dans une base de données
#
#**********************************************************************

source config/config.sh


# Chargement des métadonnées des sources
wget https://raw.githubusercontent.com/etalab/decp-rama/master/sources/metadata.json -O sources/metadata.json

mongoimport --username $mongoUsername --password $mongoPassword --host $mongoHost:$mongoPort --db $mongoDatabase --collection sources --drop --jsonArray --file sources/metadata.json

# Création et chargement des stats
./sourceStats.sh

mongoimport --username $mongoUsername --password $mongoPassword --host $mongoHost:$mongoPort --db $mongoDatabase --collection stats --drop --jsonArray --file sourceStats.json

# Chargement des données agrégées de decp-rama
wget https://www.data.gouv.fr/fr/datasets/r/16962018-5c31-4296-9454-5998585496d2 -O json/decp.json

jq '.marches' json/decp.json | mongoimport --username $mongoUsername --password $mongoPassword --host $mongoHost:$mongoPort --db $mongoDatabase --collection data --drop --jsonArray

# Recréatin de l'index
mongo -u $mongoUsername -p $mongoPassword --eval 'db.data.createIndex({"$**":"text"},{"default_language":"french"})' $mongoDatabase

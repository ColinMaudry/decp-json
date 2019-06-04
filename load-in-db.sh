#!/bin/bash

#**********************************************************************
#
# Chargement des données JSON dans une base de données
#
#**********************************************************************

source config/config.sh

wget https://www.data.gouv.fr/fr/datasets/r/16962018-5c31-4296-9454-5998585496d2 -o json/decp.json


# Chargement des métadonnées des sources
mongoimport --username $mongoUsername --password $mongoPassword --host $mongoHost:$mongoPort --db $mongoDatabase --collection data --drop --jsonArray json/decp.json

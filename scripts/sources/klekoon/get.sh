#!/bin/bash

# Récupération des données essentielles publiées par Klekoon

#Récupération de la liste des URL de DCAT :
mkdir temp

curl -s https://www.klekoon.com/declaration-profil-acheteur | tail -n +2 > temp/dcats.csv


while IFS=";" read -r siret url1 dcat coordonnees
do

    echo ""
    echo $siret
    echo ""
    curl -s "$dcat" -H "accept: application/xml" | xml2json | jq -r '.RDF.Catalog | (.dataset.distribution?) // .dataset[]?.distribution?  | .[] | select(.format.mediaTypeOrExtent == "JSON") | .accessURL.ressource' > temp/${siret}_marches


    if [[ -s temp/${siret}_marches ]]
    then

        echo '{"marches":[]}' > $siret.json

        for url in `cat temp/${siret}_marches`
        do
            curl -s "$url" > temp/marche.json
            jq --slurpfile marche temp/marche.json '.marches += ([ $marche[0] | del(.["$schema"]) ])' $siret.json > temp/$siret.json
            mv temp/$siret.json $siret.json
        done
    fi
done < "temp/dcats.csv"

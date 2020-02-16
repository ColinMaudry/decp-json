#!/bin/bash

# Récupération des données essentielles publiées par l'AIFE


# À partir du répertoire racine (où se trouve README.md), création d'un repértoire temporaire

# Récupération des données, tous les fichiers sont stockés dans le même dossier
# Le nombre de fichiers sur cette source pouvant un jour atteindre des sommets, cette solution n'est pas pérenne

# Récupération de la liste des ressources à partir de l'adresse des jeux de données.

for dataset in 5bd789ee8b4c4155bd9a0770 5c3d0d6b8b4c41333775f45a 5cc8be59634f412a53e309e8 5df410e86f44413a91d34be3

# 5be9feed8b4c41367475f40d is Private

do
    curl "https://www.data.gouv.fr/api/1/datasets/$dataset/" | jq -r '.resources[].url' >> resources.tmp
done

nbResources=`cat resources.tmp | wc -l`

echo "$nbResources ressources identifiées"

for resource in `cat resources.tmp`
do
    wget -nv $resource
done

rm resources.tmp

count=`ls -1 | wc -l`

echo ""
echo "$count fichiers téléchargés."

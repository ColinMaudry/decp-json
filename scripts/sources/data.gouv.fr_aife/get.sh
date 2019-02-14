#!/bin/bash

# Récupération des données essentielles publiées par l'AIFE


# À partir du répertoire racine (où se trouve README.md), création d'un repértoire temporaire

# Récupération des données, tous les fichiers sont stockés dans le même dossier
# Le nombre de fichiers sur cette source pouvant un jour atteindre des sommets, cette solution n'est pas pérenne

# Récupération de la liste des ressources à partir de l'adresse du jeu de données.
curl https://www.data.gouv.fr/api/1/datasets/5bd789ee8b4c4155bd9a0770/ | jq '.resources[].url' > resources.tmp

# Suppression des guillemets dans la liste ds URL des ressources
sed -i "s/\"//g" resources.tmp

cat resources.tmp
nbResources=`cat resources.tmp | wc -l`

echo "$nbResources ressources identifiées"

for resource in `cat resources.tmp`
do
    wget $resource

done

rm resources.tmp

count=`ls -1 | wc -l`

echo ""
echo "$count fichiers téléchargés."

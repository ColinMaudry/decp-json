#!/bin/bash

# Récupération des données essentielles publiées par l'AIFE


# À partir du répertoire racine (où se trouve README.md), création d'un repértoire temporaire

# Récupération des données, tous les fichiers sont stockés dans le même dossier
# Le nombre de fichiers sur cette source pouvant un jour atteindre des sommets, cette solution n'est pas pérenne

# Récupération de la liste des ressources à partir de l'adresse des jeux de données.

for dataset in 5bd789ee8b4c4155bd9a0770 5c3d0d6b8b4c41333775f45a 5be9feed8b4c41367475f40d
do
curl https://www.data.gouv.fr/api/1/datasets/$dataset/ | jq '.resources[].url' >> resources.tmp
done

# Suppression des guillemets dans la liste ds URL des ressources
sed -i "s/\"//g" resources.tmp

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

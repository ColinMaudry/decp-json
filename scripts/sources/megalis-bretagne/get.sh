	
#!/bin/bash

# Récupération des données


#wget -r -q -nc -nd -nH --accept=xml -np http://lyzen.fr/DECP/DECP-253514491-2020-09-28-01.xml


#curl https://www.data.gouv.fr/api/1/datasets// | jq -r '.resources[].url' | grep -E 'static.*xml'


# Récupération des données essentielles publiées - MEGALIS BRETAGNE


# À partir du répertoire racine (où se trouve README.md), création d'un repértoire temporaire

# Récupération des données, tous les fichiers sont stockés dans le même dossier
# Le nombre de fichiers sur cette source pouvant un jour atteindre des sommets, cette solution n'est pas pérenne

# Récupération de la liste des ressources à partir de l'adresse des jeux de données.

for dataset in donnees-essentielles-des-marches-publics-de-megalis-bretagne

# 5be9feed8b4c41367475f40d is Private

do
    curl "https://www.data.gouv.fr/api/1/datasets/$dataset/" | jq -r '.resources[].url' | grep -E 'static.*xml' >> resources.tmp
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

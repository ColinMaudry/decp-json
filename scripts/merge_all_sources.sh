#!/bin/bash

#**********************************************************************
#
# Aggrégation du JSON de toutes les sources
#
#**********************************************************************


echo "## Agrégation du JSON de toutes les sources"

export DECP_HOME=`pwd`

cd ./json

# Suppression de l'ancien fichier agrégé
if [[ -f decp.json ]]
then
    rm decp.json
fi

# Fusion des JSON de toutes les sources
$DECP_HOME/scripts/mergeJson.sh > decp_with_duplicates.json

nombreMarches=`jq '.marches | length' decp_with_duplicates.json`

echo ""
echo "Le fichier consolidé contient $nombreMarches marchés avant déduplication."
echo ""

# Déduplication des marchés
jq '{"marches": .marches | unique_by(.uid)}' decp_with_duplicates.json > decp.json
rm decp_with_duplicates.json

nombreMarchesNoDuplicates=`jq '.marches | length' decp.json`

echo ""
echo "Le fichier consolidé contient $nombreMarchesNoDuplicates marchés après déduplication."
echo "Il contenait donc $((nombreMarches-nombreMarchesNoDuplicates)) doublons."
echo ""

# Suppression des marchés exclus (voir https://github.com/etalab/decp-rama/issues/26)

# Récupération des listes de marchés exclus
if [[ ! -d exclus ]]
then
    mkdir exclus
fi
curl -L https://www.data.gouv.fr/fr/datasets/r/c0e97cb8-4530-4709-9fc3-eb264fcce8f7 -o $DECP_HOME/json/exclus/marches-fictifs.json
curl -L https://www.data.gouv.fr/fr/datasets/r/9e149698-7804-49f1-b15c-e300be611995 -o $DECP_HOME/json/exclus/marches-inexploitables.json

# Fusion des listes de marchés exclus
cd $DECP_HOME/json/exclus
$DECP_HOME/scripts/mergeJson.sh > marches-exclus.json
cd $DECP_HOME/json

# Soustraction des marchés exclus du total
jq --slurpfile excluded exclus/marches-exclus.json '{"marches": (.marches - ([$excluded[0].marches[] | del(.["raison-exclusion"])]))}' decp.json > decp_no_anomalies.json

mv decp_no_anomalies.json decp.json

nombreMarchesNoAnomalies=`jq '.marches | length' decp.json`

echo ""
echo "Le fichier consolidé contient $nombreMarchesNoAnomalies marchés après exclusions des marchés inexploitables."
echo "Il contenait donc $((nombreMarchesNoDuplicates-nombreMarchesNoAnomalies)) marchés inexploitables."
echo ""

nombreAcheteurs=`jq '.marches[].acheteur.id' decp.json | sort -u | wc -l`

echo "Nombre d'acheteurs uniques : $nombreAcheteurs"

nombreTitulaires=`jq '.marches[].titulaires[]?.id' decp.json | sort -u | wc -l`

echo "Nombre de titulaires uniques : $nombreTitulaires"

# Extraction stats par année

for annee in 2018 2019 2020
do
    jq --arg annee "$annee" '[.marches[] | select(((.dateNotification // .datePublicationDonnees) | match(".{4}") | .string) == $annee)]' decp.json > $DECP_HOME/$annee.json

    nbMarches=`jq '. | length' $DECP_HOME/$annee.json`

    echo "Nombre total de marchés pour l'année $annee : $nbMarches"

    montantTotal=`jq '[.[] |.montant?] | add' $DECP_HOME/$annee.json`

    echo "Montant total pour l'année $annee : $montantTotal"
done



# Création d'une archive ZIP avec tous les JSON de la source choisie
date=`date +%Y-%m-%d`
if [[ ! -d archives ]]
then
    mkdir archives
fi
#zip -q -9 archives/decp_$date.zip decp.json

ls -lh decp.json
ls -lh archives/decp_$date.zip

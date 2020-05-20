#!/bin/bash

echo "Nombre total de marchés (brut) :"
brut=`jq '.marches | length'  json/decp.json`
echo $brut

echo ""
echo "Nombre total de marchés (_type == Marché) :"
jq '[.marches[] | select(._type == "Marché")] | length'  json/decp.json

echo ""
echo "Nombre total de contrats de concession (_type == Contrat de concession) :"
jq '[.marches[] | select(._type == "Contrat de concession")] | length'  json/decp.json

nombreAcheteurs=`jq '.marches[].acheteur.id' json/decp.json | sort -u | wc -l`

echo "Nombre d'acheteurs uniques : $nombreAcheteurs"

nombreTitulaires=`jq '.marches[].titulaires[]?.id' json/decp.json | sort -u | wc -l`

echo "Nombre de titulaires uniques : $nombreTitulaires"

# Extraction stats par année

for annee in 2018 2019 2020
do
    jq --arg annee "$annee" '[.marches[] | select(((.dateNotification // .datePublicationDonnees) | match(".{4}") | .string) == $annee)]' json/decp.json > $DECP_HOME/$annee.json

    nbMarches=`jq '. | length' $DECP_HOME/$annee.json`

    echo "Nombre total de marchés pour l'année $annee : $nbMarches"

    montantTotal=`jq '[.[] |.montant?] | add' $DECP_HOME/$annee.json`

    echo "Montant total pour l'année $annee : $montantTotal"
done

echo ""
echo "Nombre de contrats signés : (nombre de SIRET opérateurs économiques sans dédoublonner)"
jq -r '.marches[] | if (.titulaires | length) > 0 then .titulaires[] | .id else empty end'  json/decp.json | wc -l

echo ""
echo "Nombre de marchés qui ont au moins une modification :"
jq '[.marches[] | select((.modifications | length) > 0)] | length' json/decp.json

for n in {1..3}
do
    value=`jq --arg n $n '[.marches[] | select((.modifications | length) == ($n | tonumber))] | length'   json/decp.json`
    echo "$n modification(s) :      $value"
done

echo ""
echo  "Nombre de marchés dont les deux derniers chiffres de l'ID ne correspondent pas au nombre de modifications :"

jq '[.marches[] | .modifications as $modifications | if (.id | type == "string") and (.id | endswith("0" + ($modifications|length|tostring))) | not then .uid + "," + ($modifications|length|tostring) else empty end] | length' json/decp.json

#!/bin/bash


#**********************************************************************
#
# Publication des données agrégées dans un jeu de données sur data.gouv.fr
#**********************************************************************

# /!\ Le dataset doit avoir été créé et une ressource decp.json doit avoir été ajoutée
# à ce dataset.

# fail on error
set -e

case ${CIRCLE_BRANCH} in
    # La publication n'est appliquée que sur la branche master.
    master)

    export api="https://www.data.gouv.fr/api/1"
    export dataset_id="5d1a216e6f4441513e89b93e"
    export resource_id_json="2a84ffc7-7121-48d2-a28f-85d835ed09a4"
    export resource_id_xlsx="9edac89c-874a-40f8-b01b-bb81be8afe7f"


    #API_KEY configurée dans les options de build de CircleCI
    api_key=$API_KEY



    # Test temporaire en prod (data.gouv.fr) en raison de l'indisponibilité de next.data
#     *)
#         export api="https://next.data.gouv.fr/api/1"
#         export dataset_id="5cdc1726dc470945800204fd"
#         export resource_id_json="a53049f9-3536-4dab-b0fb-8928917cb12a"
#         export resource_id_xml="61d64aa3-d853-4841-a1c5-8e12556ed57b"
#         api_key=$NEXT_API_KEY
#     ;;

if [[ ! -f ./json/releases.json or ! -f ./flattened.xslx ]]
then
    echo "Les fichiers ./json/releases.json et ./flattened.xslx doivent d'abord être générés avec la commande './scripts/makeOCDS.sh json/decp.json'."
    exit 1
fi

mv flattened.xlsx ./json/

echo "Remplacement de releases.json et flattened.xslx par leur mise à jour quotidienne"

for file in releases.json flattened.xlsx
do

case $file in
    flattened.xlsx)
    resource_id=$resource_id_xlsx
    ;;

    releases.json)
    resource_id=$resource_id_json
    ;;
esac

echo "Mise à jour de ${file}..."

curl "$api/datasets/$dataset_id/resources/${resource_id}/upload/" -F "file=@json/${file}" -H "X-API-KEY: $api_key"

done

;;
esac


# Si nous sommes le premier du mois, publication d'une nouvelle archive mensuelle

# Pas sûr de continuer sur cette voie, voir https://github.com/etalab/decp-rama/issues/6

# if [[ `date +%d` -eq "01" ]]
# then
#     datejma=`date +%d/%m/%Y`
#
#     for ext in json xml
#     do
#
#     echo "Upload du fichier comme nouvelle ressource"
#     curl "$api/datasets/$dataset_id/upload/" -F "file=@${ext}/decp.${ext}" -F "filename=decp-$datejma" -H "X-API-KEY: $api_key" > new_resource.json
#
#     new_resource_id=`jq -r .id new_resource.json`
#     echo "New resource_id : $new_resource_id"
#     jq --arg date $datejma ext ${ext^^} '.title |= "Fichier " + $ext + " du " + $date' new_resource.json > new_resource_modified.json
#
#     echo "new_resource_modified.json"
#     jq . new_resource_modified.json
#
#     echo "Modification du titre de la nouvelle ressource"
#     curl -X PUT "$api/datasets/$dataset_id/resources/$new_resource_id/" --data-binary "@new_resource_modified.json" -H "Content-type: application/json" -H "X-API-KEY: $api_key" | jq .
#
#     rm new_resource.json
#     rm new_resource_modified.json
#     done
#
# fi

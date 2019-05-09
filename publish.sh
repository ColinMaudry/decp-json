#!/bin/bash


#**********************************************************************
#
# Publication des données agrégées dans un jeu de données sur data.gouv.fr
#**********************************************************************

# /!\ Le dataset doit avoir été créé et une ressource decp.json doit avoir été ajoutée
# à ce dataset.

case ${CIRCLE_BRANCH} in
    master)

    # Pas de publication sur data.gouv.fr pour l'instant, le JDD n'est pas prêt.

    # export api="https://data.gouv.fr/api/1"
    # export dataset_id="?"
    # export resource_id="?"
    #
    # #API_KEY configurée dans les options de build de CircleCI
    # api_key=$API_KEY
    ;;

    *)
    export api="https://next.data.gouv.fr/api/1"
    export dataset_id="5cc1bb51dc470946203cc376"
    export resource_id="5f550643-9867-41ee-a77c-8d7739383dbe"
    api_key=$NEXT_API_KEY
    ;;
esac

if [[ ! -f ./json/decp.json ]]
then
    echo "Le fichier agrégé ./json/decp.json doit d'abord être généré avec la commande './merge_all_sources.sh'."
    exit 1
fi

echo "Remplacement du decp.json par sa mise à jour quotidienne"
curl $api/datasets/$dataset_id/resources/$resource_id/upload/ -F "file=@json/decp.json" -H "X-API-KEY: $api_key" | jq .success

# Si nous sommes le premier du mois, publication d'une nouvelle archive mensuelle
if [[ `date +%d` -eq "01" ]]
then
    date=`date +%d/%m/%Y`

    echo "Upload du fichier comme nouvelle ressource"
    curl -v $api/datasets/$dataset_id/upload/ -F "file=@json/decp.json" -F "filename=decp-$date" -H "X-API-KEY: $api_key" > new_resource.json

    echo "new_resource.json"
    jq . new_resource.json

    new_resource_id=`jq -r .id new_resource.json`
    echo "New resource_id : $new_resource_id"
    jq --arg date $date '.title |= "Archive du " + $date' new_resource.json > new_resource_modified.json

    echo "new_resource_modified.json"
    jq . new_resource_modified.json

    echo "Modification du titre de la nouvelle ressource"
    curl -v -X PUT $api/datasets/$dataset_id/resources/$new_resource_id/ --data-binary "@new_resource_modified.json" -H "Content-type: application/json" -H "X-API-KEY: $api_key"

    rm new_resource.json
    rm new_resource_modified.json

fi

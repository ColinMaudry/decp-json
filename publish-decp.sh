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
    export dataset_id="5cd57bf68b4c4179299eb0e9"
    export resource_id_json="16962018-5c31-4296-9454-5998585496d2"
    export resource_id_xml="17046b18-8921-486a-bc31-c9196d5c3e9c"
    export resource_id_ocds="68bd2001-3420-4d94-bc49-c90878df322c"


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

    if [[ ! -f ./json/decp.json ]]
    then
        echo "Le fichier agrégé ./json/decp.json doit d'abord être généré avec la commande './merge_all_sources.sh'."
        exit 1
    fi

    echo "Remplacement de decp.json et decp.xml par leur mise à jour quotidienne"

    for ext in json xml
    do
        case $ext in
            xml)
            resource_id=$resource_id_xml
            ;;

            json)
            resource_id=$resource_id_json
            ;;
        esac

        echo "Mise à jour de decp.${ext}..."

        curl "$api/datasets/$dataset_id/resources/${resource_id}/upload/" -F "file=@${ext}/decp.${ext}" -H "X-API-KEY: $api_key"

        date=`date "+%F"`

        echo "Publication de decp_$date.${ext}..."

        curl "$api/datasets/$dataset_id/upload/" -F "file=@results/decp_${date}.${ext}" -F "filename=decp_$date" -H "X-API-KEY: $api_key" > dailyResource.json

        idDailyResource=`jq -r '.id' dailyResource.json`

        # Change le type de ressource de 'main' à 'update'
        curl -X PUT "$api/datasets/$dataset_id/resources/$idDailyResource/" --data '{"type":"update"}' -H "Content-type: application/json" -H "X-API-KEY: $api_key"

        rm dailyResource.json

    done

    echo "Mise à jour des données au format OCDS..."
    curl "$api/datasets/$dataset_id/resources/${resource_id_ocds}/upload/" -F "file=@json/decp.ocds.json" -H "X-API-KEY: $api_key"

;;
esac

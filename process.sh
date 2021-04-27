#!/bin/bash

#**********************************************************************
#
# Toutes les opérations de récupération, correction, conversion et empaquetage
# pour la source sélectionnée ou pour toutes les sources
#**********************************************************************

# fail on error
set -e

source=$1
step=$2
mode=$3

# Pour facilement s'y retrouver dans les répertoires, création d'une variable avec le chemin de la racine de decp-rama
export DECP_HOME=`pwd`
if [[ -z $mode ]]
then
    mode=only
fi

case $source in

    all)
        sources=`jq -r '.[] | .code' $DECP_HOME/sources/metadata.json`
        echo "Sources :"
        echo $sources
        echo ""
          ## Pas de traitement des sources si l'option "nothing" est fourni
        for source in $sources
        do
            ./process.sh $source $step $mode
        done

        if [[ "$mode" == "nothing" ]]
        then
          echo ""
          echo "## Fusion de tous les fichiers JSON de source en un seul"

          scripts/mergeAllSources.sh

          echo "## Exclusions des marchés avec anomalie"

          scripts/excludeMarches.sh

          echo ""
          echo "## Correction des anomalie globales"

          scripts/fixAll.sh

          echo "## Génération des statistiques"

          scripts/stats.sh

          echo ""
          echo "Extraction des marchés du jour"

          case ${CIRCLE_BRANCH} in
              *)

              resource="https://www.data.gouv.fr/fr/datasets/r/16962018-5c31-4296-9454-5998585496d2"

              ;;

              # *)
              # export api="https://next.data.gouv.fr/api/1"
              # export resource_id_json="a53049f9-3536-4dab-b0fb-8928917cb12a"
              # api_key=$NEXT_API_KEY
              # ;;
          esac

          wget $resource -O results/decp_previous.json

          # Le fichier des marchés du jour est sauvegardé dans ./decp_{date-iso}.json
          scripts/get_new_data.sh results/decp_previous.json json/decp.json



          if [[ ! -d xml  ]]
          then
              mkdir xml
          fi

          date=`date "+%F"`
          echo ""
          echo "## Conversion du JSON agrégé en XML..."
          scripts/jsonDECP2xmlDECP.sh json/decp.json > xml/decp.xml
          ls -lh xml/decp.xml

          echo ""
          echo "## Conversion du JSON du jour en XML..."
          scripts/jsonDECP2xmlDECP.sh results/decp_$date.json > results/decp_$date.xml
          ls -lh results/decp_$date.xml

          echo ""
          echo "## Conversion du JSON agrégé au format OCDS JSON..."
          scripts/makeOCDS.sh json/decp.json
        fi
    ;;
    *)

    datetime=`date "+%FT%T"`
    echo "============================================"
    echo "$datetime : début du traitement pour source $source"
    echo ""

         case $mode in
             only)
             scripts/$step.sh $source
             ;;
             sequence)
                finalStep=$step
                for currentStep in get fix convert package
                do
                    scripts/$currentStep.sh $source
                    if [ "$currentStep" == "$finalStep" ]; then
                        break;
                    fi
                done
             ;;
             nothing)
              echo "On ne fait rien concernant les sources"
             ;;
             *)
             echo "Seules les valeurs 'only' et 'sequence' sont acceptées."
             ;;
        esac

        datetime=`date "+%FT%T"`
        echo ""
        echo "$datetime : fin du traitement pour source $source"
        echo "============================================"
        echo ""
    ;;
esac

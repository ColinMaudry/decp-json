#!/bin/bash

#**********************************************************************
#
# Toutes les opérations de récupération, correction, conversion et empaquetage
# pour la source sélectionnée ou pour toutes les sources
#**********************************************************************

source=$1
step=$2
mode=$3

# Pour facilement s'y retrouver dans les répertoires, création d'une variable avec le chemin de la racine de decp-rama
export DECP_HOME=`pwd`
echo $DECP_HOME
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
        for source in $sources
        do
            ./process.sh $source $step $mode
        done

        echo ""
        echo "## Fusion de tous les fichiers JSON de source en un seul"

        scripts/merge_all_sources.sh

        echo ""
        echo "## Conversion du JSON agrégé en XML"

        scripts/jsonDECP2xmlDECP.sh

        if [[ ! -d xml  ]]
        then
            mkdir xml
        fi

        scripts/jsonDECP2xmlDECP.sh json/decp.json > xml/decp.xml
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

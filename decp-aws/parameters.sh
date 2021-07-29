#!/usr/bin/env bash

export api="https://www.data.gouv.fr/api/1"
export dataset_id="5cdb1722634f41416ffe90e2"
# test
# export dataset_id="60f6c0de78e71c3728d8c37d"
#
#API_KEY configurée dans les options de build de CircleCI
export api_key=$API_KEY

if [[ -z ${dateDebut} ]]
then
    dateDebut="$(date +%Y)-01-01"
fi

if [[ -z ${dateFin} ]]
then
    dateFin=$(date -I -d '-1 days')
    if [[ "$(date -d $dateFin +%Y)" != "$(date -d $dateDebut +%Y)" ]]
    then
      dateFin="$(date -d ${dateDebut} +%Y)-12-31"
    fi
fi

echo "dateDebut: ${dateDebut}"
echo "dateFin: ${dateFin}"

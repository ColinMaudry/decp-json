!/bin/bash

# fail on error
set -e
set -x

source $(dirname $0)/parameters.sh

newFileName="aws-marchespublics-annee-$(date -d "$dateDebut" +%Y).json"
echo $newFileName

if [[ ! -f ${newFileName} ]]
then
    echo "Le fichier agrégé ./json/decp.json doit d'abord être généré avec la commande './merge_all_sources.sh'."
    exit 1
fi

resource_id="$(curl "${api}/datasets/${dataset_id}/" | jq -r '.resources[] | select(.url | test(".*/'$(basename $newFileName)'")) | .id')"
if [[ -z $resource_id ]]
then
  echo "Création du fichier sur data.gouv"
  curl "$api/datasets/$dataset_id/upload/" -F "file=@${newFileName}" -F "filename=$(basename ${newFileName})" -H "X-API-KEY: ${api_key}" > resource.json
  resource_id=`jq -r '.id' resource.json`
fi

echo "Upload du fichier sur data.gouv"
curl "${api}/datasets/${dataset_id}/resources/${resource_id}/upload/" -F "file=@${newFileName}" -H "X-API-KEY: ${api_key}"

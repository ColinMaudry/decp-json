#!/usr/bin/env bash

# set -x

source $(dirname $0)/parameters.sh

function download() {
  local dateNotifDebut="$1"
  local dateNotifFin="$2"
  echo "${dateNotifDebut} - ${dateNotifFin}"
  curl 'https://www.marches-publics.info/Annonces/lister' --compressed -H 'Content-Type: application/x-www-form-urlencoded' --data-raw 'IDE=DE&IDN=X&listeCPV=&IDP=X&IDR=X&txtLibre=&txtLibreLieuExec=&dateNotifDebut='$(date -I -d "$dateNotifDebut")'&dateNotifFin='$(date -I -d "$dateNotifFin")'&txtAcheteurNom=&txtAcheteurSiret=&txtTitulaireNom=&txtTitulaireSiret=&txtLibreAcheteur=&txtLibreVille=&txtLibreRef=&txtLibreObjet=&dateParution=&dateExpiration=&annee=X&Rechercher=Rechercher' -c aws-cookie.txt -s -o /dev/null


  curl 'https://www.marches-publics.info/Annonces/lister' --compressed -H 'Content-Type: application/x-www-form-urlencoded' --data-raw 'btnTelecharger=T%C3%A9l%C3%A9charger+les+Donn%C3%A9es+des+consultations' -b aws-cookie.txt -o aws-marchespublics-${dateNotifFin}.json -s

  check_and_correct aws-marchespublics-${dateNotifFin}.json
}

function check_and_correct () {
  local file="$1"
  # Ce paramètre permet de spécifier quel type de correction on souhaite appliquer.
  # De cette manière on peut enchaîner les correction en faisant l'appel qui va bien après une correction.
  # Vous pouvez regarder correct_simple pour un exemple. La fonction doit s'appeler correct_<param $2>
  local type="${2:-simple}"

  check "$file"
  local is_valid="$?"
  # JSON mal formé : tentative de correction
  if [[ "${is_valid}" != "0" ]]
  then
    echo "Fichier $file mal formé, tentative de correction $type"

    correct_${type} $file
  fi
}

function check () {
  cat "$1" | jq type 2> /dev/null
}

function correct_simple () {
  local file="$1"

  sed --regexp-extended 's/([^,:{])([^,:{\\]| )"([^,}:]| )([^,}:])/\1\2\\"\3\4/g' -i "$file"
  sed --regexp-extended '/\$schema/! s/([^,:{\\])"([^,}:]| )([^,}:])/\1\\"\2\3/' -i "$file"
  sed --regexp-extended 's/([^,:\\]| )""([,:{}])/\1\\""\2/' -i "$file"
  check_and_correct "$file" "discard_file"

}

function correct_discard_file () {
  local file="$1"

  # rm "$file"
  mv "$file" "$(dirname $file)/failed-$(basename $file)"
  echo "Fichier $file mal formé donc non conservé"

}

dateNotifDebut="$dateDebut"
dateNotifFin="$(date -I -d "$dateNotifDebut + 3 days")"

# Téléchargement des données
while [[ "${dateFin}" > "${dateNotifFin}" ]]
do
  download "${dateNotifDebut}" "${dateNotifFin}"

  sleep 2s

  dateNotifDebut="$(date -I -d "$dateNotifFin")"
  dateNotifFin="$(date -I -d "$dateNotifDebut + 3 days")"
done

if [[ "${dateNotifDebut}" < "${dateFin}" ]]
then
  download "${dateNotifDebut}" "${dateFin}"
fi

newFileName="aws-marchespublics-annee-$(date -d "$dateDebut" +%Y).json"
jq -n '{ marches: [ inputs.marches ] | add }' aws-marchespublics-$(date -d "$dateDebut" +%Y)*.json > "$newFileName"

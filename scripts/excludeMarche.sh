#/bin/bash

# Ce script ajoute les données d'un marché au fichier marches-exclus.json. Les marchés inclus dans ce fichier sont exclus du fichier consolidé des données essentielles des marchés publics français (https://www.data.gouv.fr/datasets/5cd57bf68b4c4179299eb0e9).
# Plus d'infos : https://github.com/etalab/decp-rama/issues/26

# Paramètre 1 : uid du marché à exclure
# Paramètre 2 : raison(s) de l'exclusion, séparées par des point virgules (;)


set -e

uid=$1
raison="$2"
type="$3"
telecharger=$4


if [[ ! -z $4 ]]
then
    # Télécharge les dernières données si demandé
    rm json/decp.json
    curl https://www.data.gouv.fr/fr/datasets/r/16962018-5c31-4296-9454-5998585496d2 -o json/decp.json

    # wget json/marches-fictifs-exclus.json
    # wget json/marches-inexploitables-exclus.json
fi

case "$3" in
    fictif)
        fichier="json/marches-fictifs-exclus.json"
    ;;
    inex)
        fichier="json/marches-inexploitables-exclus.json"
    ;;
esac

count=`jq '. | length' $fichier`
echo "Avant : $count marchés dans $fichier"

# Récupère les données du marché grâce à son UID
marche=`jq --arg uid "$uid" '.marches[] | select(.uid == $uid)' json/decp.json`

jq --argjson marche "$marche" --arg raison "$raison"  '. + [$marche + {"raison-exclusion": ($raison)}]' $fichier > $fichier.tmp
mv $fichier.tmp $fichier

count=`jq '. | length' $fichier`
echo "Après : $count marchés dans $fichier"

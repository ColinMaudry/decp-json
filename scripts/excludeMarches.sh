
#!/bin/bash

cd $DECP_HOME/json

# Suppression des marchés exclus (voir https://github.com/139bercy/decp-rama/issues/26)

nombreMarchesNoDuplicates=`jq '.marches | length' decp.json`

# Récupération des listes de marchés exclus
if [[ ! -d exclus ]]
then
    mkdir exclus
fi
curl -L https://www.data.gouv.fr/fr/datasets/r/c0e97cb8-4530-4709-9fc3-eb264fcce8f7 -o $DECP_HOME/json/exclus/marches-fictifs.json
curl -L https://www.data.gouv.fr/fr/datasets/r/9e149698-7804-49f1-b15c-e300be611995 -o $DECP_HOME/json/exclus/marches-inexploitables.json

# Fusion des listes de marchés exclus
cd $DECP_HOME/json/exclus
$DECP_HOME/scripts/mergeJson.sh > marches-exclus.json
cd $DECP_HOME/json

# Soustraction des marchés exclus du total
jq --slurpfile excluded exclus/marches-exclus.json '{"marches": (.marches - ([$excluded[0].marches[] | del(.["raison-exclusion"])]))}' decp.json > decp_no_anomalies.json

mv decp_no_anomalies.json decp.json

nombreMarchesNoAnomalies=`jq '.marches | length' decp.json`

echo ""
echo "Le fichier consolidé contient $nombreMarchesNoAnomalies marchés après exclusions des marchés inexploitables."
echo "Il contenait donc $((nombreMarchesNoDuplicates-nombreMarchesNoAnomalies)) marchés inexploitables."
echo ""

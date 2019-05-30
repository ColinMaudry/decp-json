

echo "Nombre total de marchés:"
jq '.marches | length'  json/decp.json

echo "Nombre total de marchés (_type == Marché) :"
jq '[.marches[] | select(._type == "Marché")] | length'  json/decp.json

echo "Nombre total de contrats de concession (_type == Contrat de concession) :"
jq '[.marches[] | select(._type == "Contrat de concession")] | length'  json/decp.json


echo "Nombre de marchés qui ont au moins une modification :"
jq '[.marches[] | select((.modifications | length) > 0)] | length'   json/decp.json

for n in {1..3}
do
    value=`jq --arg n $n '[.marches[] | select((.modifications | length) == ($n | tonumber))] | length'   json/decp.json`
    echo "$n modification(s) :      $value"
done

echo ""
echo  "Nombre de marchés dont les deux derniers chiffres de l'ID ne correspondent pas au nombre de modifications :"

jq '[.marches[] | .modifications as $modifications | if ((.id | type == "string") and (.id | endswith("0" + ($modifications|length|tostring)))) then .uid + "," + ($modifications|length|tostring) else empty end] | length' json/decp.json

echo ""

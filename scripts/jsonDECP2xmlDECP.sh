#!/bin/bash
source=$1

length=`jq -r '.marches | length' $source`
chunk_size=30000

start_range=0
end_range=$chunk_size

# Bash always floors the result of divisions to the lower integer. 3/2 = 1.
nb_chunks_raw=$(( length / chunk_size ))
nb_chunks=$(( nb_chunks_raw + 1 ))

echo '<?xml version="1.0" encoding="utf-8"?>
<marches xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="https://raw.githubusercontent.com/139bercy/format-commande-publique/master/marches.xsd">'

while [[ ! $current_chunk -eq $nb_chunks ]]
do
  (( current_chunk++ ))

  json=chunk_$current_chunk.json
  jq --arg startr $start_range --arg endr $end_range '{"marches":.marches[$startr|tonumber:$endr|tonumber]}' $source | \

    # JSON to generic XML structure
    json2xml.py | \

    # Generic XML structure to DECP XML
    xsltproc scripts/xslt/postJsonConversion.xsl - | \

    # Indentation
    xmllint --format --encode utf-8 - | \

    # Filter out XML declaration and nesting element as we feed a file that has them already
    grep -v "^<?xml" | grep -vE "^<(\/)?marches"

  end_range=$(( end_range + chunk_size ))
  start_range=$(( start_range + chunk_size ))
done

echo "</marches>"

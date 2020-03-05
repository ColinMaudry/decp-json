#!/bin/bash

source config/config.sh

# Chargement des métadonnées des sources
curl -s https://raw.githubusercontent.com/etalab/decp-rama/master/sources/metadata.json > source-metadata.json

sources=`jq -r '.[] | .code' source-metadata.json`


if [[ -f nbMarches_* ]]
then
    rm nbMarches_*
fi

if [[ ! -d logs/all ]]
then
     mkdir -p logs/all
fi

# Initialise JSON

echo "[]" > sourceStats.json

# Make CSV header line
head="date"
for source in $sources
do
    head="$head,$source,${source}_new"
done

echo $head > sourceStats.csv



# Download logs from circle

# Jobs before 51 are rubbish
i=51

# Get last job number
lastLog=`curl -s "https://circleci.com/api/v1.1/project/github/etalab/decp-rama/tree/master?circle-token=$circleApiKey&limit=1&filter=completed" | jq -r '.[0].build_num'`

echo "last log = $lastLog"

while [[ ! $i -gt $lastLog ]]
do
    log=logs/all/$i.log

    # Get job metadata
    if [[ ! -s logs/all/$i.json ]]
    then
        curl -s https://circleci.com/api/v1.1/project/github/etalab/decp-rama/$i -u "$circleApiKey:" > logs/all/$i.json
    fi

    date=`jq -r '.start_time | split("T") | .[0]' logs/all/$i.json`
    url=102
    grepNb=`grep "début du traitement pour source" $log | wc -l`

    while [ $url -lt 105 -a $grepNb -le 1 ]
    do
        echo "Downloading logs ($i $url)..."
        curl -s "https://circleci.com/api/v1.1/project/github/etalab/decp-rama/$i/output/$url/0?file=true" > $log

        grepNb=`grep "début du traitement pour source" $log | wc -l`

        ((url++))
    done

    if [[ $grepNb -gt 1 ]]
    then
        cp $log logs/$date.log
    fi

    ((i++))
done

# Processing logs to extract stats

for log in `ls logs/*.log`
do

    echo ""
    echo "Processing $log..."
    dateObject="{\"sources\":["


    date=`basename -s .log $log`

    csvLine="$date"

    for source in $sources
    do
        nbMarches=`grep "$source contient" $log | sed -r 's/^.*contient ([0-9]+) marchés/\1/' | tr -d "\r\n "`

        csvLine="$csvLine,$nbMarches"

        if [[ -f nbMarches_$source ]]
        then
            prevNbMarches=`cat nbMarches_$source | tr -d "\r\n "`
            nbNewMarches=$((nbMarches - prevNbMarches))
        else
            nbNewMarches=0
        fi
        echo $nbMarches > nbMarches_$source

        dateObject="$dateObject
        {\"source\":\"$source\",\"marches\":$nbMarches,\"nouveauxMarches\":$nbNewMarches},"
        csvLine="$csvLine,$nbNewMarches"
    done

    # Close the date object

    dateObject="${dateObject::-1}],\"date\":\"$date\"}"

    echo $dateObject > dateObject.json
    echo $csvLine >> sourceStats.csv

    jq --slurpfile object dateObject.json '. += $object'  sourceStats.json > sourceStatsTemp

    mv sourceStatsTemp sourceStats.json

done

jq '.' sourceStats.json | head

head sourceStats.csv

#rm job.json dateObject.json
rm nbMarches*



# Close JSON

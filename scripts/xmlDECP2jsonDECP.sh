#!/bin/bash

# Ce script convertit les données en DECP JSON

xmllint --format $1 | sed 's/<!\[CDATA\[\([^]]*\)\]\]>/\1/g' | xml2json | jq -f $DECP_HOME/scripts/jq/jsonDECP.jq

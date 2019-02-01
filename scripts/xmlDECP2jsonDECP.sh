#!/bin/bash

# Ce script convertit les données en DECP JSON

xml2json $1 | jq -f $DECP_HOME/scripts/jq/jsonDECP.jq

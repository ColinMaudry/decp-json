#!/bin/bash

# Ce script convertit les données DECP JSON en DECP XML
echo ""
echo "Conversion de $1 vers DECP XML..."

json2xml.py $1 | xsltproc scripts/xslt/postJsonConversion.xsl - | xmllint --format --encode utf-8 -


#!/bin/bash

# Ce script convertit les données de l'AIFE en DECP JSON

source=$1

$DECP_HOME/scripts/sources/data.gouv.fr_aife/convert.sh $source

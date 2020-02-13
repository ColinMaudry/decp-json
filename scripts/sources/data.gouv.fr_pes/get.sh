#!/bin/bash

# Récupération des données


# À partir du répertoire racine (où se trouve README.md), création d'un repértoire temporaire

# Récupération des données, tous les fichiers sont stockés dans le même dossier
# Le nombre de fichiers sur cette source pouvant un jour atteindre des sommets, cette solution n'est pas pérenne

# Un minimum de log est nécessaire pour maintenir le run Circle, autrement :
# "SIGHUP received,redirecting output to ‘wget-log’. Too long with no output (exceeded 10m0s)"
wget https://files.data.gouv.fr/decp/dgfip-pes-decp.xml

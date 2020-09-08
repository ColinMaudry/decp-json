
#!/bin/bash

# Récupération des données essentielles publiées sur la plateforme Atexo Maximilien

# À partir du répertoire racine (où se trouve README.md), création d'un repértoire temporaire

# Récupération des données, tous les fichiers sont stockés dans le même dossier
# Le nombre de fichiers sur cette source pouvant un jour atteindre des sommets, cette solution n'est pas pérenne

# Récupération de la liste des ressources à partir de l'adresse des jeux de données.

source=$1

curl -L "https://www.data.gouv.fr/fr/datasets/r/350042f4-3fda-4233-940e-f21ab9e081ac" > $source.xml



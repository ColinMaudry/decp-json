#!/bin/bash

# Faites une copie de fichier "config.sh", puis personnalisez son contenu.


# Configuration de mongoDB

mongoUsername=decp
mongoPassword=1234
mongoPort=27017
mongoHost=localhost

# Il est préférables que la base de données ci-desous doit dédiée aux DECP
# Collections créées dans cette base de données :
# - data
# - sources
mongoDatabase=decp

adminPassword=""

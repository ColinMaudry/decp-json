#!/bin/bash

# Ce script initialise ou réinitialise la base de données MongoDB afin de (re)partir de zéro.

# La base de données et l'utilisateur doivent avoir été créés.

# ATTENTION : toutes les données de la base de données sélectionnée seront supprimées.



source ./config/config.sh

# Suppression des collections

mongo -u $mongoUsername -p $mongoPassword --port $mongoPort --eval 'db.data.drop()' $mongoDatabase

mongo -u $mongoUsername -p $mongoPassword --port $mongoPort --eval 'db.sources.drop()' $mongoDatabase

# Création des collections

mongo -u $mongoUsername -p $mongoPassword --port $mongoPort --eval 'db.createCollection("data")' $mongoDatabase

mongo -u $mongoUsername -p $mongoPassword --port $mongoPort --eval 'db.createCollection("sources")' $mongoDatabase

# Création de l'index texte sur la collection data

mongo -u $mongoUsername -p $mongoPassword --eval 'db.data.createIndex({"$**":"text"},{"default_language":"french"})' $mongoDatabase

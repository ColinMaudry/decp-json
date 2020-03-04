#!/bin/bash

# Ce script initialise ou réinitialise la base de données MongoDB afin de (re)partir de zéro.

# La base de données et l'utilisateur doivent avoir été créés.

# ATTENTION : toutes les données de la base de données sélectionnée seront supprimées.



source ./config/config.sh

if [[ $1 -eq "fromScratch" ]]
then
    # Ajout de l'admin "root"
    ansible localhost -m mongodb_user -a "database=admin name=admin password=$adminPassword roles=readWriteAnyDatabase,userAdminAnyDatabase state=present"

    # Activaction de l'authentification
    sudo sed -i 's/#auth = true/auth = true/' /etc/mongodb.conf

    #Redémarrage de MongoDB pour prendre en compte l'activiatio de l'auth
    sudo systemctl restart mongodb.service

    # Ajout de l'utilisateur normal
    ansible localhost -m mongodb_user -a "database=$mongoDatabase name=$mongoUsername password=$mongoPassword roles=readWrite,dbAdmin state=present login_user=admin login_password=$adminPassword login_database=admin"
fi


# Suppression des collections

mongo -u $mongoUsername -p $mongoPassword --port $mongoPort --eval 'db.data.drop()' $mongoDatabase

mongo -u $mongoUsername -p $mongoPassword --port $mongoPort --eval 'db.sources.drop()' $mongoDatabase

# Création des collections

mongo -u $mongoUsername -p $mongoPassword --port $mongoPort --eval 'db.createCollection("data")' $mongoDatabase

mongo -u $mongoUsername -p $mongoPassword --port $mongoPort --eval 'db.createCollection("sources")' $mongoDatabase

mongo -u $mongoUsername -p $mongoPassword --port $mongoPort --eval 'db.createCollection("stats")' $mongoDatabase

# Création de l'index texte sur la collection data

mongo -u $mongoUsername -p $mongoPassword --eval 'db.data.createIndex({"$**":"text"},{"default_language":"french"})' $mongoDatabase

#!/bin/bash

# Remplace les anciens noms de procédure par les nouveaux (schéma 1.5, arrêté 22 mars 2019)
sed -i 's/"procedure"\: "Procédure concurrentielle avec négociation"/"procedure"\: "Procédure avec négociation"/' json/decp.json

sed -i 's/"procedure"\: "Procédure négociée avec mise en concurrence préalable"/"procedure"\: "Procédure avec négociation"/' json/decp.json


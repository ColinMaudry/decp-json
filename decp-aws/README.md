# DECP AWS

> Toutes les données essentielles de la commande publique agrégées et converties provenant du site https://www.marches-publics.info/Annonces/lister

Ces scripts permettent d'extraire automatiquement les données provenant de https://www.marches-publics.info/Annonces/lister.

Ce site n'offre pas une API au sens propre du terme, il est donc nécessaire de faire du scraping afin de récupérer les données.
De plus il n'est pas possible de récupérer les données en une seule fois.
De ce fait, le script `get-aws-marchespublics.sh` se chargent d'effectuer de manière itérative un ensemble de requête pour récupérer les données.
Une requête nous permet de récupérer 3 jours de données.
Lors de la dernière mise à jour, le script génèrera donc 100 requêtes.

Nous définissons un fichier par an et le fichier de l'année courante est mis à jour en fonction de la règle cron du fichier [config.yml](../config.yml).
La première version de ce cron était de faire tourner l'extraction tous les dimanches matin.

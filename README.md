# DECP JSON

> Chargement des données essentielles de la commande publique en base de données et production de statistiques.

**Version 2.0.1**

Rappel de ce que sont les données essentielles de la commande publique (ou DECP) [sur le blog de data.gouv.fr](https://www.data.gouv.fr/fr/posts/le-point-sur-les-donnees-essentielles-de-la-commande-publique/).

L'objectif de ce projet est d'exploiter [les données essentielles de la commande publique (DECP)](https://www.data.gouv.fr/fr/datasets/5cd57bf68b4c4179299eb0e9/) et de les rendre intelligibles.

![Progression du nombre de marchés par source](https://plot.ly/~ColinMaudry/1.png)

Projets connexes :

- [decp-rama](https://github.com/etalab/decp-rama)
- [format-commande-publique](https://github.com/etalab/format-commande-publique)
- [sirene-ld-web](https://github.com/ColinMaudry/sirene-ld-web) (https://sireneld.io/commande-publique)

## Pré-requis

- [jq](https://stedolan.github.io/jq/) pour requêter le fichier JSON (disponible dans les dépôts Ubuntu)
- une instance MongoDB et `mongoimport` pour le chargement
- pouvoir exécuter des scripts bash
- ansible pour initialiser MongoDB

## Mode d'emploi

Pour commencer, vous devez faire une copie de `config/config_template.sh` en `config/config.sh`.

```
cp config/config_template.sh config/config.sh
```

Puis éditez le contenu de `config/config.sh` pour configurer l'accès à votre base de données MongoDB.

### (Ré)initialiser la base de données MongoDB

La base de données configurée dans `config/config.sh`.

Ensuite, vous pouvez initialiser la base de données (suppression/création des collections, création de l'index textuel) :

```
./dbInit.sh
```

Si vous partez d'une base vide, vous pouvez en plus créer les utilisateurs et activer l'authentification avec :

```
./dbInit.sh fromScratch
```

### Génération des statistiques

```
./sourceStats.sh
```

### Charger des données de marchés publiques et les statistiques dans MongoDB

```
./load-in-db.sh
```

## Contact

Vous pouvez :

- m'écrire un mail à colin@maudry.com
- me trouver sur Twitter ([@col1m](https://twitter.com/col1m))
- intéragir avec ce dépôt sur Github (issues, pull request).

## License

Le code source de ce projet est publié sous licence [Unlicense](http://unlicense.org).

## Notes de version

### 2.0.1

- ajout de la gestion de redirection (`curl -L`) pour la récupréation des DECP

### 2.0.0

- migration du code d'agrégation vers [decp-rama](https://github.com/etalab/decp-rama)
- production de stats

#### 1.3.1

- correction d'un bug dans la fusion des JSON

### 1.3.0

- ajout des données de e-marchespublics.com
- couvertures des trois datasets de l'AIFE
- gestion des sources de données qui ne nécessitent pas de conversion
- amélioration du workflow (get > convert > fix > package > load-in-db)

### 1.2.0

- correction d'une anomalie dans les données `marches-publics.info` (certains marchés n'ont pas de `_type`)
- nouvelles données dans `/json`
- ajout d'un script de (ré)initialisation de MongoDB

### 1.1.0

- support des [données publiées sur marches-publics.info](https://www.marches-publics.info/mpiaws/index.cfm) (`marches-publics.info`)
- ajout de la date du dernier téléchargement dans les métadonnées
- amélioration de la scructure des scripts
- ajout de `all.sh`, pour traiter intégralement une source (sauf le chargement en base de données)

### 1.0.0

- support des [données PES marché publiées sur data.gouv.fr](https://www.data.gouv.fr/fr/datasets/5bd0b6fd8b4c413d0801dc57/) (`data.gouv.fr_pes`)

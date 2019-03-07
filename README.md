# DECP JSON

> Toutes les données essentielles de la commande publique converties en JSON.

**Version 1.2.0**

Rappel de ce que sont les données essentielles de la commande publique (ou DECP) [sur le blog de data.gouv.fr](https://www.data.gouv.fr/fr/posts/le-point-sur-les-donnees-essentielles-de-la-commande-publique/).

L'objectif de ce projet est d'identifier toutes les sources de DECP, et de créer des scripts permettant de produire des fichiers utilisables ([exemple fictif sur le dépôt officiel](https://github.com/etalab/format-commande-publique/blob/master/exemples/json/paquet.json)) au [format JSON réglementaire](https://github.com/etalab/format-commande-publique/tree/master/sch%C3%A9mas/json).

La procédure standard est la suivante :

1. J'agrège toutes les données possibles dans leur format d'origine, **XML ou JSON** (les DECP n'existent pas dans d'autres formats)
2. Je les stocke dans `/sources` dans un répertoire spécifique à la source des données. En effet, selon la source, les données n'ont pas besoin des même traitements pour être utilisables (nettoyage, réparation de la structure, correction de l'encodage, conversion depuis XML)
3. Je les convertis au format JSON réglementaire, en rajoutant un champ `source`. Certaines données sources n'étant pas valides (par exemple si certains champs manquent), les données JSON ne seront pas non plus valides. Je prends le parti de les garder.
4. Je crée une archive ZIP avec le JSON converti. Ces archives ZIP sont sauvegardées dans le dépot Git, vous les trouverez dans `/json`

**Si vous avez connaissance de données essentielles de la commande publique facilement accessibles (téléchargement en masse possible) et qui ne sont pas encore identifiées ci-dessous, merci de [m'en informer](#contact).**

À terme, les données converties seront principalement mises à disposition sur https://sireneld.io/data.

## Pré-requis

- [xml2json](https://github.com/Cheedoong/xml2json) pour la conversion de XML vers JSON
- [jq](https://stedolan.github.io/jq/) pour la conversion JSON vers JSON (disponible dans les dépôts Ubuntu)
- une instance MongoDB et `mongoimport` pour le chargement
- pouvoir exécuter des scripts bash

## Mode d'emploi

Vous trouverez les `code` possibles dans le tableau plus bas.

Pour commencer, vous devez faire une copie de `config/config_template.sh` en `config/config.sh`.

```
cp config/config_template.sh config/config.sh
```

Puis éditez le contenu de `config/config.sh` pour configurer l'accès à votre base de données MongoDB.

### (Ré)initialiser la base de données MongoDB

La base de données configurée dans `config/config.sh` et l'utilisateur doivent être créés par vos soins.

Ensuite, vous pouvez initialiser la base de données (suppression/création des collections, création de l'index textuel) :

```
./dbInit.sh
```

### Télécharger les données

```
./get.sh [code]
```
### Convertir les données

Les données doivent avoir été téléchargées.

```
./convert.sh [code]
```

### Créer une archive ZIP des données JSON converties

Les données doivent avoir été converties.

```
./package.sh [code]
```

### Charger des données JSON converties dans MongoDB

Les données doivent avoir été converties.

```
./load-in-db.sh [code]
```


### Supprimer les données JSON converties (mais pas les ZIP)

Les données doivent avoir été converties. Il est recommander de créer une archive ZIP auparavant, au cas où.

```
./clean.sh [code]
```


## Sources de données

| Code                   | Description                                    | URL                                                           | Statut                   |
| ---------------------- | ---------------------------------------------- | ------------------------------------------------------------- | ------------------------ |
| `data.gouv.fr_pes`     | Données des collectivités issues du PES Marché | https://www.data.gouv.fr/fr/datasets/5bd0b6fd8b4c413d0801dc57 | **Intégrée**             |
|                        | Données de l'État publiées par l'AIFE          | https://www.data.gouv.fr/fr/datasets/5bd789ee8b4c4155bd9a0770 | Intégrée prochainement   |
|                        | DECP publiées par achatpublic.com              | [https://www.achatpublic.com](https://frama.link/47M71Xz2)    | Téléchargement compliqué |
| `marches-publics.info` | DECP publiées par marches-publics.info (AWS)   | https://www.marches-publics.info/mpiaws/index.cfm             | **Intégrée**             |
|                        |                                                |                                                               |                          |

## Contact

Vous pouvez :

- m'écrire un mail à colin@maudry.com
- me trouver sur Twitter ([@col1m](https://twitter.com/col1m))
- intéragir avec ce dépôt sur Github (issues, pull request).

## License

Le code source de ce projet est publié sous licence [Unlicense](http://unlicense.org).

## Notes de version

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

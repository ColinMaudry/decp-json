# DECPrama

> Toutes les données essentielles de la commande publique agrégées et converties
.

**Version 1.3.1**

Rappel de ce que sont les données essentielles de la commande publique (ou DECP) [sur le blog de data.gouv.fr](https://www.data.gouv.fr/fr/posts/le-point-sur-les-donnees-essentielles-de-la-commande-publique/).

L'objectif de ce projet est d'identifier toutes les sources de DECP, et de créer des scripts permettant de produire des fichiers utilisables ([exemple fictif sur le dépôt officiel](https://github.com/etalab/format-commande-publique/blob/master/exemples/json/paquet.json)) au [format JSON réglementaire](https://github.com/etalab/format-commande-publique/tree/master/sch%C3%A9mas/json).

La procédure standard est la suivante :

1. Nous agrégeons toutes les données possibles dans leur format d'origine, **XML ou JSON** (les DECP n'existent pas dans d'autres formats)
2. Nous les stockons dans `/sources` dans un répertoire spécifique à la source des données. En effet, selon la source, les données n'ont pas besoin des même traitements pour être utilisables (nettoyage, réparation de la structure, correction de l'encodage)
3. Nous les convertissons au format JSON ou XML réglementaire selon le format de récupération, en rajoutant un champ `source` qui permet d'identifier la source d'origine (voir le tableau ci-dessous). Certaines données sources n'étant pas valides (par exemple si certains champs manquent), les données ne seront pas non plus valides. Nous avons pris le parti de les garder et de signaler ces anomalies.
4. Nous agrégeons les données XML et les JSON et les publions sur un jeu de données sur data.gouv.fr (prochainement).

**Si vous avez connaissance de données essentielles de la commande publique facilement accessibles (téléchargement en masse possible) et qui ne sont pas encore identifiées ci-dessous, merci de [nous en informer](#contact).**

## Pré-requis

- [xml2json](https://github.com/Cheedoong/xml2json) pour la conversion de XML vers JSON (binaire Linus amd64 inclus dans `./scripts/bin`)
- [jq](https://stedolan.github.io/jq/) pour la conversion JSON vers JSON (disponible dans les dépôts Ubuntu)
- [xsltproc](http://xmlsoft.org/XSLT/xsltproc2.html) pour la correction d'anomalies dans certaines sources XML (disponible dans les dépôts Ubuntu)
- pouvoir exécuter des scripts bash

## Mode d'emploi

Vous trouverez les `code` possibles dans le tableau plus bas.

Pour commencer, vous devez faire une copie de `config/config_template.sh` en `config/config.sh`.

### Traitement séquentiel d'une source ou de toutes les sources

Le script `process.sh` permet de lancer une étape de traitement ou toutes les étapes de traitement pour une source ou toutes les sources configurées.

Les sources configurées sont visibles dans `sources/metadata.json`, et récapitulées dans le tableau ci-dessous.

Les étapes de traitement et leur code respectif sont les suivantes, dans l'ordre :

1. `get` (téléchargement des données de la source)
2. `fix` (correction des anomalies pour optimiser l'utilisabilité des données et tendre vers la conformité aux schémas, si besoin)
3. `convert` (conversion des données XML en JSON, si besoin)
4. `package` (création d'un seul fichier JSON pour la source et archivage sous forme de ZIP)

Le script `process.sh` prend trois paramètres, dans cette ordre :

1. le `code` de la source à traiter, ou `all` pour traiter toutes les sources
2. le `code` de l'étape de traitement à effectuer sur la ou les sources
3. le `mode` de sélection de l'étape : `only` ou rien pour n'éxecuter que l'étape sélectionnée, ou `sequence` pour sélectionner toutes les étapes jusqu'à l'étape sélectionnée.

Si la source sélectionnée n'a pas de script pour une étape donnée, cette étape sera ignorée.

Exemples :

```
# Ne lancer que l'étape de conversion XML > JSON pour la source data.gouv.fr_pes
./process.sh data.gouv.fr_pes convert only

# Ne lancer que l'étape de téléchargement des données, pour toutes les sources configurées
./process.sh all get

# Lancer toutes les étapes jusqu'à convert (get, fix, convert) pour toutes les sources configurées
./process.sh all convert sequence

# Lancer toutes les étapes de traitement sur toutes les sources
./process.sh all package sequence

```

## Sources de données

| Code                   | Description                                      | URL                                                           | Statut                                                                               |
| ---------------------- | ------------------------------------------------ | ------------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| `data.gouv.fr_pes`     | DECP des collectivités issues du PES Marché      | https://www.data.gouv.fr/fr/datasets/5bd0b6fd8b4c413d0801dc57 | **Intégrée**                                                                         |
| `data.gouv.fr_aife`    | DECP de l'État publiées par l'AIFE               | https://www.data.gouv.fr/fr/datasets/5bd789ee8b4c4155bd9a0770 | **Intégrée**                                                                         |
|                        | DECP publiées par achatpublic.com                | [https://www.achatpublic.com](https://frama.link/47M71Xz2)    | Pas de téléchargement en masse                                                       |
| `marches-publics.info` | DECP publiées par marches-publics.info (AWS)     | https://www.marches-publics.info/mpiaws/index.cfm             | [Plus de téléchargement en masse](https://github.com/ColinMaudry/decp-json/issues/3) |
| `e-marchespublics.com` | DECP publiées par e-marchespublics.com (Dematis) | https://www.data.gouv.fr/fr/datasets/5c0a7845634f4139b2ee8883 | **Intégrée**                                                                         |
|                        | DECP des membres de Mégalis Bretagne             | https://marches.megalisbretagne.org/                          | Très peu de DECP publiées                                                            |

## Contact

- commandepublique@data.gouv.fr
- intéragir avec ce dépôt sur Github (issues, pull request).

## License

Le code source de ce projet est publié sous licence [MIT](https://opensource.org/licenses/MIT).

## Notes de version

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

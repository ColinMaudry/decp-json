# DECPrama

> Toutes les données essentielles de la commande publique agrégées et converties

**Version 1.11.2**

Rappel de ce que sont les données essentielles de la commande publique (ou DECP) [sur le blog de data.gouv.fr](https://www.data.gouv.fr/fr/posts/le-point-sur-les-donnees-essentielles-de-la-commande-publique/).

L'objectif de ce projet est d'identifier toutes les sources de DECP, et de créer des scripts permettant de produire des fichiers utilisables (**[jeu de données sur data.gouv.fr](https://www.data.gouv.fr/fr/datasets/5cd57bf68b4c4179299eb0e9)**) au [formats JSON et XML réglementaires](https://github.com/etalab/format-commande-publique/tree/master/sch%C3%A9mas).

La procédure standard est la suivante :

1. Nous agrégeons toutes les données possibles dans leur format d'origine, **XML ou JSON** (les DECP n'existent pas dans d'autres formats)
2. Nous les stockons dans `/sources` dans un répertoire spécifique à la source des données. En effet, selon la source, les données n'ont pas besoin des même traitements pour être utilisables (nettoyage, réparation de la structure, correction de l'encodage)
3. Nous les convertissons au format JSON réglementaire si la source est en XML. Certaines données sources n'étant pas valides, nous corrigeons ce qui peut être corrigé (par exemple le format d'une date).  Si certains champs manquent dans les données, nous avons pris le parti de les garder et de [signaler ces anomalies](https://github.com/etalab/decp-rama/labels/anomalie).
4. Nous convertissons l'agrégat au format JSON au fichier XML
4. Nous publions les agrégats XML et JSON sur **[un jeu de données sur data.gouv.fr](https://www.data.gouv.fr/fr/datasets/5cd57bf68b4c4179299eb0e9)**
5. Nous publions également chaque jour un fichier des nouveaux marchés sur le même jeu de données

**Si vous avez connaissance de données essentielles de la commande publique facilement accessibles (téléchargement en masse possible) et qui ne sont pas encore identifiées ci-dessous, merci de [nous en informer](#contact).**

## Pré-requis

- [xml2json](https://github.com/Cheedoong/xml2json) pour la conversion de XML vers JSON (binaire Linus amd64 inclus dans `./scripts/bin`)
- [jq](https://stedolan.github.io/jq/) pour la modification des fichiers JSON (disponible dans les dépôts Ubuntu)
- [xsltproc](http://xmlsoft.org/XSLT/xsltproc2.html) pour la correction d'anomalies dans certaines sources XML (disponible dans les dépôts Ubuntu)
- [json2xml](https://github.com/edsu/json2xml) pour la conversion XML vers JSON
- [libxml2-utils] pour l'outil `xmllint` (disponible dans les dépôts Ubuntu)
- [wget](https://doc.ubuntu-fr.org/wget)
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

## Publication du résultat

Le script `publish.sh` permet de publier les fichiers produits sur [le jeu de données](https://www.data.gouv.fr/fr/datasets/5cd57bf68b4c4179299eb0e9).

Les fichiers JSON et XML doivent avoir été produits préalablement, par exemple avec :

```
./process.sh all package sequence
```

## Sources de données

| Code                   | Description                                          | URL                                                                           | Statut                                                                                        |
| ---------------------- | ---------------------------------------------------- | ----------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| `data.gouv.fr_pes`     | DECP des collectivités issues du PES Marché          | https://www.data.gouv.fr/fr/datasets/5bd0b6fd8b4c413d0801dc57                 | **Intégrée**                                                                                  |
| `data.gouv.fr_aife`    | DECP de l'État publiées par l'AIFE                   | https://www.data.gouv.fr/fr/datasets/5bd789ee8b4c4155bd9a0770                 | **Intégrée**                                                                                  |
| `marches-publics.info` | DECP publiées par marches-publics.info (AWS)         | https://www.marches-publics.info/mpiaws/index.cfm                             | [Mises à dispo par la communauté](https://www.data.gouv.fr/datasets/5cdb1722634f41416ffe90e2) |
| `e-marchespublics.com` | DECP publiées par e-marchespublics.com (Dematis)     | https://www.data.gouv.fr/fr/datasets/5c0a7845634f4139b2ee8883                 | **Intégrée**                                                                                  |
|                        | DECP des membres de Mégalis Bretagne                 | https://marches.megalisbretagne.org/                                          | Très peu de DECP publiées                                                                     |
| `grandlyon`            | Marchés du Grand Lyon publiés sur data.grandlyon.com | https://data.grandlyon.com/citoyennete/marchf-public-de-la-mftropole-de-lyon/ | **Intégrée**                                                                                  |

## Contact

- commandepublique@data.gouv.fr
- intéragir avec ce dépôt sur Github (issues, pull request).

## Licence

Le code source de ce projet est publié sous licence [MIT](https://opensource.org/licenses/MIT).

## Notes de version

#### 1.11.2

- Allongement de la durée de timeout CircleCI

#### 1.11.1

- Suppression d'une commande qui dépendait de la création d'une archive ZIP

### 1.11.0

- Ajout d'un jeu de données supplémentaire de l'AIFE (https://www.data.gouv.fr/fr/datasets/aife-de-13001977100018/)
- Ajout de stats dans les logs
- Suppression de la création d'archive ZIP

### 1.10.0

- Données PES marché : récupération du fichier consolidé plutôt des centains de fichiers individuels (#GreenIT)

### 1.9.0

- Amélioration de la production des fichiers JSON et XML du jour lorsqu'il y a plus de 1000 nouveaux marchés sur une journée
- Prise en compte des [marchés exclus (fictifs ou inexploitables)](https://github.com/etalab/decp-rama/issues/26)

#### 1.8.3 (31/08/2019)

- Seul le premier espace (s'il y en avait) dans les identifiants de marchés était traité. S'il y avait plus d'un espace, il décalait le compte des nouveaux marchés. J'ai modifié l'expression régulière pour qu'elle soit globale.

#### 1.8.2 (13/08/2019)

- `wget` parcourait également les dossiers parents et frères de /decp, téléchargeant les fichiers XML de /lcsqa. C'est corrigé avec l'option `-np`pour `no-parent`.

#### 1.8.1 (04/07/2019)

- pour les marchés provenant de l'AIFE (`data.gouv.fr_aife`), si une `datePublicationDonnees` est manquante, elle est récupérée à partir du nom du fichier XML publié par l'AIFE
- pour les marchés provenant du portail du Grand Lyon (`grandlyon`), si plusieurs `datePublicationDonnees` sont présentes, seule la première est retenue

### 1.8.0 (20/06/2019)

- Correction d'un bug dans la génération des nouveaux marchés du jour
- dédublication des marchés via l'`uid` (concaténation du SIRET de l'acheteur et de l'`id` du marché)

### 1.7.0 (10/06/2019)

- image docker plutôt que de réinstaller toutes les dépendances dans la VM à chaque run de CircleCI
- les données ne sont récupérées et consolidées que du mardi au samedi matin (peu ou pas de nouvelles données le weekend)
- seul les runs sur la branche `master` se terminent par une publication sur data.gouv.fr, pas sur `develop` et autres branches

### 1.6.0 (30/05/2019)

- les fichiers des nouveaux marchés du jour sont maintenant [typés "Mise à jour" sur data.gouv.fr](https://www.data.gouv.fr/datasets/5cd57bf68b4c4179299eb0e9)

#### 1.5.1 (28/05/2019)

- correction d'une erreur dans la conversion JSON > XML

### 1.5.0 (25/05/2019)

- conversion de l'agrégat vers XML
- correction des soucis de téléchargement et de traitement
- ajout des données du Grand Lyon (merci Nathalie Vernus-Prost)
- création d'un fichier des nouveaux marchés du jour

### 1.4.0 (09/05/2019)

- **fork de [decp-json](https://github.com/ColinMaudry/decp-json) ([Colin Maudry](https://twitter.com/col1m)) par Etalab pour la publication des données sur data.gouv.fr**
- passage à la licence MIT
- amélioration du mécanisme d'orchestration du traitement avec `process.sh`
- automatisation du process récupération/traitement/publication dans CircleCI

#### 1.3.1 (05/04/2019)

- correction d'un bug dans la fusion des JSON

### 1.3.0 (04/04/2019)

- ajout des données de e-marchespublics.com
- couvertures des trois datasets de l'AIFE
- gestion des sources de données qui ne nécessitent pas de conversion
- amélioration du workflow (get > convert > fix > package > load-in-db)

### 1.2.0 (07/03/2019)

- correction d'une anomalie dans les données `marches-publics.info` (certains marchés n'ont pas de `_type`)
- nouvelles données dans `/json`
- ajout d'un script de (ré)initialisation de MongoDB

### 1.1.0 (27/02/2019)

- support des [données publiées sur marches-publics.info](https://www.marches-publics.info/mpiaws/index.cfm) (`marches-publics.info`)
- ajout de la date du dernier téléchargement dans les métadonnées
- amélioration de la scructure des scripts
- ajout de `all.sh`, pour traiter intégralement une source (sauf le chargement en base de données)

### 1.0.0 (02/02/2019)

- support des [données PES marché publiées sur data.gouv.fr](https://www.data.gouv.fr/fr/datasets/5bd0b6fd8b4c413d0801dc57/) (`data.gouv.fr_pes`)

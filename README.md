# DECPrama

> Toutes les données essentielles de la commande publique agrégées et converties

[![CircleCI](https://circleci.com/gh/139bercy/decp-rama.svg?style=svg)](https://circleci.com/gh/139bercy/decp-rama)

Ce document décrit la manière dont les données essentielles de la commande publique sont consolidées techniquement. Vous trouverez davantage d'information sur les données essentielles de la commande publique sur https://139bercy.github.io/decp-docs/.

**Version 1.15.1**

Rappel de ce que sont les données essentielles de la commande publique (ou DECP) [sur le blog de data.gouv.fr](https://www.data.gouv.fr/fr/posts/le-point-sur-les-donnees-essentielles-de-la-commande-publique/).

L'objectif de ce projet est d'identifier toutes les sources de DECP, et de créer des scripts permettant de produire des fichiers utilisables (**[jeu de données sur data.gouv.fr](https://www.data.gouv.fr/fr/datasets/5cd57bf68b4c4179299eb0e9)**) au [formats JSON et XML réglementaires](https://github.com/139bercy/format-commande-publique/tree/master/sch%C3%A9mas).

La procédure standard est la suivante :

1. Nous agrégeons toutes les données possibles dans leur format d'origine, **XML ou JSON** (les DECP n'existent pas dans d'autres formats)
2. Nous les stockons dans `/sources` dans un répertoire spécifique à la source des données. En effet, selon la source, les données n'ont pas besoin des même traitements pour être utilisables (nettoyage, réparation de la structure, correction de l'encodage)
3. Nous les convertissons au format JSON réglementaire si la source est en XML. Certaines données sources n'étant pas valides, nous corrigeons ce qui peut être corrigé (par exemple le format d'une date).  Si certains champs manquent dans les données, nous avons pris le parti de les garder et de [signaler ces anomalies](https://github.com/139bercy/decp-rama/labels/anomalie).
4. Nous convertissons l'agrégat au format JSON (format réglementaire + format [OCDS](https://standard.open-contracting.org/latest/fr/)) et au format XML réglementaire
4. Nous publions les agrégats JSON, XML et OCDS sur **[un jeu de données sur data.gouv.fr](https://www.data.gouv.fr/fr/datasets/5cd57bf68b4c4179299eb0e9)**
5. Nous publions également chaque jour un fichier des nouveaux marchés sur le même jeu de données

**Si vous avez connaissance de données essentielles de la commande publique facilement accessibles (téléchargement en masse possible) et qui ne sont pas encore identifiées ci-dessous, merci de [nous en informer](#contact).**

## Pré-requis

- [xml2json](https://github.com/Cheedoong/xml2json) pour la conversion de XML vers JSON (binaire Linus amd64 inclus dans `./scripts/bin`)
- [jq](https://stedolan.github.io/jq/) pour la modification des fichiers JSON (disponible dans les dépôts Ubuntu, version >=1.6 car la 1.5 a un bug qui pose problème dans une conversion des fichiers JSON en XML)
- [xsltproc](http://xmlsoft.org/XSLT/xsltproc2.html) pour la correction d'anomalies dans certaines sources XML (disponible dans les dépôts Ubuntu)
- [json2xml](https://github.com/edsu/json2xml) pour la conversion XML vers JSON
- [libxml2-utils] pour l'outil `xmllint` (disponible dans les dépôts Ubuntu)
- [wget](https://doc.ubuntu-fr.org/wget)
- pouvoir exécuter des scripts bash

## Mode d'emploi

Vous trouverez les `code` possibles dans le tableau plus bas.

### Traitement séquentiel d'une source ou de toutes les sources

Le script `process.sh` permet de lancer une étape de traitement ou toutes les étapes de traitement pour une source ou toutes les sources configurées.

Les sources configurées sont visibles dans `sources/metadata.json`.

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
# Lancer toutes les étapes de traitement sur toutes les sources
./process.sh all package sequence

# Ne lancer que l'étape de conversion XML > JSON pour la source data.gouv.fr_pes
./process.sh data.gouv.fr_pes convert only

# Ne lancer que l'étape de téléchargement des données, pour toutes les sources configurées
./process.sh all get

# Lancer toutes les étapes jusqu'à convert (get, fix, convert) pour toutes les sources configurées
./process.sh all convert sequence
```

## Publication du résultat

1. Les fichiers JSON, XML et OCDS doivent avoir été produits préalablement, par exemple avec :

```
./process.sh all package sequence
```

2. Déclarez une clé API permettant de modifier [le jeu de données](https://www.data.gouv.fr/fr/datasets/5cd57bf68b4c4179299eb0e9) :

```
export API_KEY=eyJhbGciOkJIUzI1NiJ9.eyJfc2VyIjoiNTM0ZmZmM2xhO2E3MjkyYzY0YTc3NTI2IiwidGltZSI6...
```

3. Exécutez le script `publish-decp.sh` permet de publier les fichiers produits sur [le jeu de données](https://www.data.gouv.fr/fr/datasets/5cd57bf68b4c4179299eb0e9).

```
./publish-decp.sh
```

## Sources de données agrégrées

Se reporter au fichier `sources/metadata.json`.

## Contact

- Pour toute question technique ou juridique, une seule adresse : decp@finances.gouv.fr
- Il est également possible d'ntéragir directement avec ce dépôt sur GitHub (issues, pull request) pour demander des évolutions ou signaler des anomalies.

## Licence

Le code source de ce projet est publié sous licence [MIT](https://opensource.org/licenses/MIT).


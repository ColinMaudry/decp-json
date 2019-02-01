# DECP JSON

> Toutes les données essentielles de la commande publique converties en JSON.

Rappel ce que sont les données essentielles de la commande publique [sur le blog de data.gouv.fr](https://www.data.gouv.fr/fr/posts/le-point-sur-les-donnees-essentielles-de-la-commande-publique/).

Pour ce faire :

1. J'agrège toutes les données possibles dans leur format d'origine, XML ou JSON
2. Je les stocke dans `/sources` dans un répertoire spécifique à la source des données. En effet, selon la source, les données n'ont pas besoin des même traitements pour être utilisables (nettoyage, réparation de la structure, correction de l'encodage, conversion depuis XML)
3. Je les convertis au format JSON réglementaire, en rajoutant un champ `source`. Certaines données sources n'étant pas valide (par exemple si certains champs manquent), les données JSON ne seront pas non plus valides. Je prends le parti de les garder.
4. Je crée une archive ZIP avec le JSON converti. Ces ZIP sont sauvegardés dans le dépot Git, vous les trouverez dans `/json`

## Pré-requis

- [xml2json](https://github.com/Cheedoong/xml2json) pour la conversion de XML vers JSON
- [jq](https://stedolan.github.io/jq/) pour la conversion JSON vers JSON (disponible dans les dépôts Ubuntu)
- pouvoir exécuter des scripts bash

## Mode d'emploi

Vous trouverez les `code` dans le tableau plus bas.

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

### Supprimer les données JSON converties

Les données doivent avoir été converties. Il est recommander de créer une archive ZIP auparavant, au cas où.

```
./clean.sh [code]
```


## Sources de données

| Code             | Description                           | URL                                                            | Statut       |
| ---------------- | ------------------------------------- | -------------------------------------------------------------- | ------------ |
| `data.gouv.fr_pes` | Données publiées via le PES Marché    | https://www.data.gouv.fr/fr/datasets/5bd0b6fd8b4c413d0801dc57/ | **Intégrée** |
|                  | Données de l'État publiées par l'AIFE | https://www.data.gouv.fr/fr/datasets/5bd789ee8b4c4155bd9a0770  | Identifiée   |

## License

Le code source des scripts de projet est publié sous license [Unlicense](http://unlicense.org).

## Notes de version

### 1.0.0

- support des [données PES marché publiées sur data.gouv.fr](https://www.data.gouv.fr/fr/datasets/5bd0b6fd8b4c413d0801dc57/) (`data.gouv.fr_pes`)

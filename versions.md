## Notes de version

### 1.15.1 (11 décembre 2020)

- Ajout des données du profil d'acheteur **Megalis Bretagne**
- Ajout d'un fichier de version dédié

### 1.15.0 (12 novembre 2020)

- Ajout des données de marches.maximilien.fr et du profil d'acheteur Ternum BFC
- Amélioration des instructions pour une exécution locale des scripts
- Script partagé pour la conversion XML>JSON ([convert-xml.sh](https://github.com/139bercy/decp-rama/blob/master/scripts/sources/shared/convert-xml.sh))

### 1.14.2 (15 juillet 2020)

- Remplacement de l'adresse email de contact

### 1.14.1 (24 juin 2020)

- Conversion JSON > XML par blocs de 30 000 marchés pour limiter la consommation de mémoire ([#42](https://github.com/139bercy/decp-rama/issues/42))

### 1.14.0 (11 juin 2020)

- Fixation de la durée de timeout (`no_output_timeout`) CircleCI à 4 heures.

### 1.13.0 (21 mai 2020)

- Migration du dépôt vers l'organisation @139bercy
- Remplacement des anciens noms de procédure par les nouveaux dans les données consolidées (voir [https://github.com/139bercy/format-commande-publique/issues/48](https://github.com/139bercy/format-commande-publique/issues/48))
- Correction de bug : le SIRET de l'autorité concédante est maintenant ajoutée à l'`uid` des contrats de concession ([#39](https://github.com/139bercy/decp-rama/issues/39))

### 1.12.0 (28 avril 2020)

- Ajout du format [OCDS](https://standard.open-contracting.org/latest/fr/) aux formats de sortie

#### 1.11.6

- Fixation de la durée de timeout (`no_output_timeout`) CircleCI à 1 heure 30 minutes. fin de ne pas surconsommer les crédits Circle d'Etalab. Si les timeout sont rares, le traitement des données se fera exceptionnellement en local. Autrement, il faudra migrer vers une autre solution.

#### 1.11.5

- Allongement de la durée de timeout (`no_output_timeout`) CircleCI (1 heure 45 minutes => 10 heures)

#### 1.11.4

- Allongement de la durée de timeout (`no_output_timeout`) CircleCI (1 heure => 1 heure 45 minutes)

#### 1.11.3

- Données AIFE : Plus de discrimination sur l'extension de fichier ([#30](https://github.com/139bercy/decp-rama/issues/30))

#### 1.11.2

- Allongement de la durée de timeout CircleCI (`no_output_timeout`) (10 minutes => 1 heure)

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
- Prise en compte des [marchés exclus (fictifs ou inexploitables)](https://github.com/139bercy/decp-rama/issues/26)

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

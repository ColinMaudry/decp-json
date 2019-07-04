Afin de publier les [données essentielles de la commande publique](https://www.data.gouv.fr/fr/datasets/5cd57bf68b4c4179299eb0e9/) (DECP) dans un format standard et intéropérable à l'échelle internationale, nous les convertissons publions au format OCDS (Open Contracting Data Standard, [Standard de Données sur la Commande Publique Ouverte (fr)](http://standard.open-contracting.org/latest/fr/)). Ce format a été conçu par l'[Open Contracting Partnership (en)](https://www.open-contracting.org/) (en) en collaboration avec des acheteurs publics de nombreux pays.

Les scripts de publication sont consultables sur [le dépôt des scripts de traitement et publication des DECP](https://github.com/etalab/decp-rama/tree/master/scripts/jq/ocds).

## Structure du format DECP

Pour information, les données de concessions ne sont pour l'instant pas converties au format OCDS. Cette section ne traite donc que données de marchés au sens strict, et non des contrats de concession.

Le format DECP français, dont les schémas se trouvent [ici](https://github.com/etalab/format-commande-publique), se constitue principalemetn de deux parties : le "tronc" des données, contenu à la racine `marche`, et le bloc `modifications`.

Le tronc décrit les données du marché telle que connues au moment de l'attribution du marché. Dans la vie des données d'une même procédure, les données de ce tronc ne changent donc pas, à l'exception des deux derniers chiffres de l'identifiants de marché (`id`), qui s'incrémentent à chaque modification. Tous les changements sont enregistrés dans le bloc de données `modifications`.

Ainsi, si une modification

- de la **durée**
- du **montant**
- ou des **titulaires**

du marché intervient, les données sont republiées, avec un bloc `modification` ajouté à la suite des autres (comme dernier enfant) dans le bloc `modifications`. Ce bloc `modification` contient la ou les données modifiées (`dureeMois`, `montant` et/ou `titulaires`), ainsi que trois métadonnées :

- `objetModification`
- `datePublicationDonneesModification`
- `dateNotificationModification`

## Choix structurels en OCDS

Afin de reproduire cette structure au format OCDS, nous avons fait les choix suivants (se référer au [schéma d'instance (fr)](http://standard.open-contracting.org/latest/fr/schema/release/) (*release*)).

### Identifiants

#### Dans les DECP

L'identifiant `id` des DECP est défini par l'acheteur, et est normalement unique pour chaque acheteur (`acheteur.id`). Il est règlementairement composé de :

- l'année de notification du marché sur quatre chiffres
- d'un identfiant alphanumérique (lettres, chiffres et sympboles autorisés)
- d'un numéro de séquence indiquant le nombre de modifications (3% des identifiants n'ont pas ce numéro de séquence)

Exemple : `2018k6l-bLQ56r00` (aucune modification)

Afin de matérialiser cette unicité et avoir un identfiant unique au niveau national, les scripts de consolidation de la mission Etalab ajoutent un nouveau champ `uid`, qui se compose :

- du SIRET de l'acheteur (`acheteur.id`) (14 chiffres)
- de l'`id`

Exemple : `834553729000152018k6l-bLQ56r00`

#### Dans l'OCDS

Dans le standard OCDS, trois ensembles de données doivent être identifiés, avec des contraintes spécifiques en terme d'unicité

**La procédure de passation, identifiée par son `ocid`**

L'`ocid` identifie une procédure de passation de marché, de sa genèse jusqu'à sa conclusion. Cet identifiant doit être unique au niveau mondial, de façon à permettre l'aggrégation et l'analyse de données de marchés publics provenant de différents pays.

Un `ocid` est structuré de la façon suivante :

- un préfixe, attribué par l'Open Contracting Partnership, unique pour chaque producteur de données OCDS. Exemple, le préfixe utilisé par la DINSIC pour la publication des données agrégées : `ocds-78apv2`.
- un identfiant unique à l'échelle du producteur de données

Pour la conversion des DECP, le choix était presque simple : il suffit de concaténer le préfixe et notre `uid` unique au niveau nationale. Malheureusement, l'`uid` identifie une version des données de la procédure, et non toute la procédure, en raison des deux derniers chiffres du numéro de séquence. L'`uid` changera donc à chaque modification des données, et ne peut donc pas être utilisée telle quelle pour composer l'`ocid`, qui doit être stable.

La construction de l'`ocid` se fait donc de la manière suivante :

1) Vérifier que les derniers chiffres de l'`uid` correspondent au nombre de `modifications` dans les DECP
    - si oui, on les enlève pour avoir un `uid` non versionné
    - si non, on ne touche à rien car on suppose que l'`uid` ne changera pas à chaque modification (certains acheteurs publique n'ajoute pas ce suffixe de séquence à leurs `id`)
2) Ajouter le préfixe et un tiret avant

**/!\\** Cette méthode nous expose au risque que des `uid` non corrélées au nombre de modifications se terminent accidentellement par deux chiffres correspondant au nombre de modifications, et donc que l'`ocid` soit tronquée par erreur. Nous réfléchissons à une solution, la plus évidente étant de contacter les producteurs pour corriger le problème à la source.

Exemples de conversions `uid` > `ocid` :

- `288500010000132018MA181101` (1 `modification` dans les DECP) > `ocds-78apv2-288500010000132018MA1811` (suppression du numéro de séquence `01`)
- `834553729000152018k6l-bLQ56r01` (2 `modification` dans les DECP) > `ocds-78apv2-834553729000152018k6l-bLQ56r01` (pas de numéro de séquence)

**L'instance (*release*)**

Le principal modèle de publication du standard OCDS est la publication d'instances (*releases*) de données décrivant une évolution datée dans une procédure, identifiée par un `ocid`. L'identifiant d'une instance doit être unique au sein d'une procédure. Pour des raisons pratiques, l'identifiant d'une instance est souvent un `ocid` étendu.

Dans le cadre de la publication des DECP, la problématique et la solution retenue découle des choix faits pour l'`ocid`. L'`id` d'instance est composée :

- de l'`ocid` que décrit l'instance
- du numéro de la modification portée par l'instance, c'est-à-dire, lorsqu'il est présent, le numéro de séquence extrait de l'`uid`, loesqu'il est absent, le nombre de `modifications` présentes dans les DECP

Exemples d'`id` d'instance (basés sur les exemples de la section précédentes) :

- `ocds-78apv2-288500010000132018MA1811-01` (1 `modification` dans les DECP)
- `ocds-78apv2-834553729000152018k6l-bLQ56r01-02` (2 `modification` dans les DECP)

**L'objet**

Un contrat et une attribution sont des objets qui doivent être identifiés dans des donées OCDS. Cet identifiant doit être unique au sein d'une même procédure (`ocid`).

Comme pour l'`id` d'instance, nous avons décidé de la baser sur l`ocid` pour rendre sa filiation plus évidente. Une fois l'`ocid` déterminé, la construction de l'`id` d'objet est aisée :

- `ocid`
- type d'objet (`contract`, `award`, `amendment`, `item`, etc.)
- numéro de l'objet

Exemples :

- `ocds-78apv2-288500010000132018MA1811-award-1`
- `ocds-78apv2-834553729000152018k6l-bLQ56r01-contract-1`
- `ocds-78apv2-834553729000152018k6l-bLQ56r01-amendment-1`

Les DECP décrivant des attributions de lots, elles ne décrivent qu'un seul `item` (car elles ne renseignent qu'un seul code CPV) et qu'un seul `award`. Il ne devrait donc y avoir que des identifiants `item-1` et `award-1` dans les données OCDS produites à partir des DECP.

Lorsque les DECP ne renseignent qu'un seul titulaire, un seul objet `contrat` est créé pour l'ensemble de la procédure, même s'il peut subir des modification de durée ou de montant.

**TODO** : préciser la relation award/contract/nombre de titulaires.

### Dates

### Modifications et impact sur la structure des instances

- le "tronc" de données hors `modifications` est systématiquement republié dans les nouvelles instances
- si un fichier DECP n'a pas de modification :
    - un bloc `award` et un bloc `contract` sont créés pour accueillir les données DECP
    - le `tag` d'instance utilisé est `award`
    - la `date` de l'instance est égale à `datePublicationDonnees`
- si la dernière modification d'un fichier DECP contient une modification de montant ou de durée :
    - un bloc `award` et un bloc `contract` sont créés, mais seul le bloc `contract` intègre les données du bloc `modification`, le bloc `award` garde les données du tronc
    - le bloc `contract.amendements` est renseigné
    - le `tag` d'instance utilisé est `contractAmendment`
    - la `date` de l'instance est égale à `datePublicationDonneesModification`
- si la dernière modification d'un fichier DECP contient une modification des titulaires :
    - seul un bloc `award` est créé et il intègre les nouvelles données des titulaires
    - le `tag` d'instance utilisé est `awardUpdate`
    - la `date` de l'instance est égale à `datePublicationDonneesModification`
- si la dernière modification d'un fichier DECP ne contient pas de modification des titulaires, du montant ou de la durée (ex : correction dans un document de la procédure) :
    - un bloc `award` et un bloc `contract` sont créés, mais le bloc `contract` se limite aux champs `id`, `awardID` et `amendments`
    - le `tag` d'instance utilisé est `awardUpdate`
    - la `date` de l'instance est égale à `datePublicationDonneesModification`

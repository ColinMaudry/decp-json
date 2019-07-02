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

du marché intervient, les données sont republiées, avec un bloc `modification` ajouté à `modifications`. Ce bloc `modification` contient la ou les données modifiées (`dureeMois`, `montant` et/ou `titulaires`), ainsi que trois métadonnées :

- `objetModification`
- `datePublicationDonneesModification`
- `dateNotificationModification`

## Choix structurels en OCDS

Afin de reproduire cette structure au format OCDS, nous avons fait les choix suivants (se référer au [schéma d'instance (fr)](http://standard.open-contracting.org/latest/fr/schema/release/) (*release*)).

### Identifiants

### Modifications

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

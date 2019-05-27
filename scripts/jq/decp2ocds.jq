def getIdScheme(typeIdentifiant):
    typeIdentifiant |
    if . == "SIRET" then "FR-INSEE"
    else .
    end;

def getBuyer:
    . | (if (."_type" == "Marché") then
    .acheteur else .autoriteConcedante end)
    ;
def getSupplier:
    . | (if (."_type" == "Marché") then
    .titulaires[] else .concessionnaires[] end)
    ;

{
	"version": "1.1",
	"uri": "http://files.data.gouv.fr/" ,
    "#comment": "URL where this file can be downloaded",
	"publishedDate": $datetime,
	"publisher": {
		"name": "Secrétariat Général du Gouvernement",
		"scheme": "FR-INSEE",
		"uid": "12000101100010"
	},
	"license": "https://www.etalab.gouv.fr/licence-ouverte-open-licence",
	"publicationPolicy": $datasetUrl,
	"releases": [
        .marches[] | {
		"ocid": ($ocidPrefix + "-" + .uid),
		"id": .id,
		"date": .datePublicationDonnees,
		"tag": (if (.modifications | length) > 0
            then "awardUpdate" else "award" end),
		"initiationType": "tender",
		"parties": [(getBuyer |
            {
                    "name": .nom,
                    "id": .id,
                    "roles": ["buyer"],
                    "identifier": {
                        "scheme": "FR-INSEE",
                        "id": .id,
                        "legalName": .nom
                    }}),
              (getSupplier | {
                      "name": .denominationSociale,
                      "id": .id,
                      "roles": ["supplier"],
                      "identifier": {
                          "scheme": getIdScheme(.typeIdentifiant),
                          "id": .id,
                          "legalName": .denominationSociale
                      }
                  })
		],
		"buyer": {
			"name": .acheteur.nom,
			"id": .acheteur.id
		},
		"awards": [{
			"id": "??",
			"description": .objet,
			"status": "active",
			"date": .dateNotification,
			"value": {
				"amount": 200000,
				"currency": "EUR"
			},
			"suppliers": [(.titulaires[] | {
                  "name": .denominationSociale,
                  "id": .id
                  })
              ],
			"items": [{
				"id": "1",
				"description": .objet,
				"classification":
                (if .codeCPV != null then {
					"scheme": "CPV",
					"id": .codeCPV
				} else null
                end)
			}],
			"contractPeriod": {
				"durationInDays": (.dureeMois * 30.5 )
			},
			"amendments": [{
				"#comment": "content of moficiations/modification (last, if any)"
			}]
		}],
		"language": "fr"
	}]
}

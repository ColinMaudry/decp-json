def getIdScheme(typeIdentifiant):
    typeIdentifiant |
    if . == "SIRET" then "FR-INSEE"
    else .
    end;

def getBuyer:
    . | (if (."_type" == "Marché") then
    .acheteur else .autoriteConcedante end)
    ;
def getSupplier(lastModif):
    . | (if (."_type" == "Marché") then
    (lastModif.titulaires // .titulaires) else .concessionnaires end) |
    if (. == null) then empty else .[] end
    ;
def formatDate:
    . + "T00:00+02:00"
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
        .marches[] |
        (.modifications | last) as $lastModif |
        {"ocid": ($ocidPrefix + "-" + .uid),
		"id": .id,
		"date": .datePublicationDonnees,
		"tag": [(if (.modifications | length) > 0
            then "awardUpdate" else "award" end)],
		"initiationType": "tender",
		"parties":
         [(getBuyer |
            {
                    "name": .nom,
                    "id": .id,
                    "roles": ["buyer"],
                    "identifier": {
                        "scheme": "FR-INSEE",
                        "id": .id,
                        "legalName": .nom
                    }})
                    ,
              (getSupplier($lastModif) | {
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
		"buyer": getBuyer | {
			"name": .nom,
			"id": .id
		},
		"awards": [{
            "#comment":"ID à déterminer",
			"id": "??",
			"description": .objet,
			"status": "active",
			"date": .dateNotification | formatDate,
			"value": {
				"amount": ($lastModif.montant // .montant),
				"currency": "EUR"
			},
			"suppliers": [(getSupplier($lastModif) | {
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
				"durationInDays": (($lastModif.dureeMois //.dureeMois) * 30.5 | floor )
			},
			"amendments": [
                if (.modifications|length > 0) then
                .modifications | last | {
                    "date" : .dateNotificationModification | formatDate,
                    "description": .objetModification,
                    "#comment": "il manque les releases précédentes et suivantes"
                }
                else empty
                end
			]
		}],
		"language": "fr"
	}]
}

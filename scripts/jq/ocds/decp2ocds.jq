def getIdScheme(typeIdentifiant):
    typeIdentifiant |
    if . == "SIRET" then "FR-RCS"
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
def chooseReleaseTag(lastModif):

    if (lastModif|type == "object")|not then ["award"] else
        [] |
        if (lastModif.titulaires | type == "array") then . + ["awardUpdate"] else . end
        | if (lastModif.montant | type == "number") or (lastModif.dureeMois | type == "number") then . + ["contractAmendment"] else . end
    end
    ;
def formatDate(date):
    #date | .
    date | match("(\\d\\d\\d\\d-\\d\\d-\\d\\d)(.*)?") | (.captures[0].string + "T00:00:00" + (if .captures[1].string == "" then "Z" else .captures[1].string end))
    ;
{
	"version": "1.1",
	"uri": "http://files.data.gouv.fr/" ,
    "#comment": "URL where this file can be downloaded",
	"publishedDate": $datetime,
	"publisher": {
		"name": "Secrétariat Général du Gouvernement",
		"scheme": "FR-RCS",
		"uid": "12000101100010"
	},
	"license": "https://www.etalab.gouv.fr/licence-ouverte-open-licence",
	"publicationPolicy": $datasetUrl,
	"releases": [
        .marches[] |
        (.modifications | last) as $lastModif |
        ($ocidPrefix + "-" + .uid) as $ocid |
        {"ocid": $ocid,
		"id": .id,
		"date": formatDate(.datePublicationDonnees),
        "language": "fr",
		"tag": chooseReleaseTag($lastModif),
		"initiationType": "tender",
		"parties":
         [(getBuyer |
            {
                    "name": .nom,
                    "id": .id,
                    "roles": ["buyer"],
                    "identifier": {
                        "scheme": "FR-RCS",
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
			"id": ($ocid + "-award-1"),
			"description": .objet,
			"status": "active",
			"date": formatDate(.dateNotification),
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
				"id": ($ocid + "-item-1"),
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
			}
			}]
		}
    ],
}

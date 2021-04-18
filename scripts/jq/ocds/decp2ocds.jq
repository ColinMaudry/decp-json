# def walk(f):
#       . as $in
#       | if type == "object" then
#           reduce keys_unsorted[] as $key
#             ( {}; . + { ($key):  ($in[$key] | walk(f)) } ) | f
#       elif type == "array" then map( walk(f) ) | f
#       else f
#       end;
def getIdScheme(typeIdentifiant):
    typeIdentifiant |
    if . == "SIRET" then "FR-RCS"
    else .
    end;
def getBuyer:
    . | (if (."_type" == "Marché") then
    .acheteur else .autoriteConcedante end)
    ;
def getSupplier:
    . | (if (."_type" == "Marché") then
    .titulaires else .concessionnaires end) |
    if (. == null) then empty else unique_by(.id) | .[] end
    ;
def formatDate(date):
    if (date|type == "string") then
        date | match("(\\d{4}-\\d\\d-\\d\\d)(.*)?") | (.captures[0].string + "T00:00:00" + (if .captures[1].string == "" then "Z" else .captures[1].string end))
    else null end
    ;

def getDurationInDays(durationInMonths):
    durationInMonths * 30.5 | floor
    ;
def getReleaseIdMeta:
    {
        "id": .uid,
        "seq": (if (.modifications |length) < 10 then  ("0"  + (.modifications |length | tostring)) else (.modifications | length | tostring) end),
        "nbModif": (.modifications |length)
    }
    ;

{
	"version": "1.1",
	"uri": $packageUri,
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
        if (._type == "Marché" and (.modifications | length) == 0) then
        .modifications as $modifications |
        getReleaseIdMeta as $releaseIdMeta |
        ($ocidPrefix + "-" + $releaseIdMeta.id) as $ocid |
        ($ocid + "-" + .datePublicationDonnees + "-" + $releaseIdMeta.seq) as $releaseId |
        [{
          "id": ($ocid + "-item-1"),
          "description": .objet,
          "classification":
          (if .codeCPV != null then
            {
              "scheme": "CPV",
              "id": .codeCPV
            }
          else
            empty
          end)
        }] as $items |
      {
        "ocid": $ocid,
  		  "id": $releaseId,
        "decpUID": .uid,
  		  "date": (formatDate(.datePublicationDonnees) // $datetime),
        "language": "fr",
  		  "tag": ["award","contract"],
  		  "initiationType": "tender",
  		  "parties":
          [
            (getBuyer |
              {
                "name": .nom,
                "id": ("FR-RCS-" + .id + "-buyer"),
                "roles": ["buyer"],
                "identifier": {
                    "scheme": "FR-RCS",
                    "id": .id,
                    "legalName": .nom
                }
              }
            )
                      ,
            (getSupplier |
              {
                "name": .denominationSociale,
                "id": (getIdScheme(.typeIdentifiant) + "-" + .id + "-supplier") ,
                "roles": ["supplier"],
                "identifier": {
                    "scheme": getIdScheme(.typeIdentifiant),
                    "id": .id,
                    "legalName": .denominationSociale
                }
              }
            )
          ],
    		"buyer": getBuyer |
          {
    			"name": .nom,
    			"id": ("FR-RCS-" + .id + "-buyer")
    		  },
  		  "awards": [
          {
    			  "id": ($ocid + "-award-1"),
    			  "description": .objet,
    			  "status": "active",
    			  "date": formatDate(.dateNotification),
    			  "value": {
    				  "amount": .montant,
    				  "currency": "EUR"
    			  },
    			  "suppliers": [
              (getSupplier |
                {
                  "name": .denominationSociale,
                  "id": (getIdScheme(.typeIdentifiant) + "-" + .id + "-supplier")
                }
              )
            ],
    			  "items": $items,
    			  "contractPeriod": {
    				  "durationInDays": getDurationInDays(.dureeMois)
    			  }
  			  }
        ],
        "contracts": [
          {
            "id": ($ocid + "-contract-1"),
            "awardID": ($ocid + "-award-1"),
            "value": {
                "amount": .montant,
                "currency": "EUR"
            },
            "description": .objet,
            # "amendments": (if ($releaseIdMeta.nbModif > 0) then
            #     [ {
            #         "id": ($ocid + "-amendment-" + ($releaseIdMeta.seq | tonumber | tostring)),
            #         "date": (formatDate($lastModif.dateNotificationModification)),
            #         "rationale":  ($lastModif.objetModification),
            #         "amendsReleaseID": ($releaseIdMeta.id + "-" + ($releaseIdMeta.seq | tonumber | . - 1 |
            #         tostring | if length < 2 then "0" + . else . end)),
            #         "releaseID": $releaseId
            #         } ]
            #     else null end),
            "period":   {
                "durationInDays": getDurationInDays(.dureeMois)
            },
            "status": (if $releaseIdMeta.nbModif > 0 then "active" else "pending" end),
            "items": $items
          }
        ]
  		} else empty end
    ],
}
# Added to remove all null properties from the resulting tree
# | walk(
#     if type == "object" then
#         with_entries(select( .value != null and .value != {} and .value != []))
#     elif type == "array" then
#         map(select( . != null and . != {} and . != []))
#     else
#         .
#     end
# )

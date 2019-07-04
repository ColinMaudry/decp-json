def walk(f):
      . as $in
      | if type == "object" then
          reduce keys_unsorted[] as $key
            ( {}; . + { ($key):  ($in[$key] | walk(f)) } ) | f
      elif type == "array" then map( walk(f) ) | f
      else f
      end;
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
    if (date|type == "string") then
        date | match("(\\d{4}-\\d\\d-\\d\\d)(.*)?") | (.captures[0].string + "T00:00:00" + (if .captures[1].string == "" then "Z" else .captures[1].string end))
    else null end
    ;

def getReleaseDate(lastModif):
    if (lastModif|type == "object")|not then formatDate(.datePublicationDonnees)
    else formatDate(lastModif.datePublicationDonneesModification)
    end
    ;
def getDurationInDays(durationInMonths):
    durationInMonths * 30.5 | floor
    ;
def getReleaseIdMeta:
    (.uid | match("..$") | .string) as $suffix |
    if
    ((.uid | type) == "string")
    and ($suffix | test("\\d\\d")) and ($suffix | tonumber) == (.modifications |length)
    then
    {
        "id": (.uid | rtrimstr($suffix)),
        "seq": $suffix,
        "nbModif": (.modifications |length)
    }
    else
    {
        "id": .uid,
        "seq": (if (.modifications |length) < 10 then  ("0"  + (.modifications |length | tostring)) else (.modifications | length | tostring) end),
        "nbModif": (.modifications |length)
    } end
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

        if (._type == "Marché") then
        .modifications as $modifications |
        getReleaseIdMeta as $releaseIdMeta |
        ($releaseIdMeta.id + "-" + $releaseIdMeta.seq) as $releaseId |
        ($modifications | last) as $lastModif |
        ($ocidPrefix + "-" + $releaseIdMeta.id) as $ocid |
        [{
        "id": ($ocid + "-item-1"),
        "description": .objet,
        "classification":
        (if .codeCPV != null then {
            "scheme": "CPV",
            "id": .codeCPV
        } else empty
        end)
    }] as $items |
    {
        "ocid": $ocid,
		"id": $releaseId ,
		"date": getReleaseDate($lastModif),
        "language": "fr",
		"tag": chooseReleaseTag($lastModif),
		"initiationType": "tender",
		"parties":
        [
            (getBuyer |
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
				"amount": .montant,
				"currency": "EUR"
			},
			"suppliers": [(getSupplier($lastModif) | {
                  "name": .denominationSociale,
                  "id": .id
                  })
              ],
			"items": $items,
			"contractPeriod": {
				"durationInDays": getDurationInDays(.dureeMois)
			}
			}],
            "contracts":[
                {
                    "id": ($ocid + "-contract-1"),
                    "awardID": ($ocid + "-award-1"),
                    "value": {
                        "amount": ($lastModif.montant // .montant),
                        "currency": "EUR"
                    },
                    "description": .objet,
                    "amendments": (if ($releaseIdMeta.nbModif > 0) then
                        [ {
                            "id": ($ocid + "-amendment-" + ($releaseIdMeta.seq | tonumber | tostring)),
                            "date": (formatDate($lastModif.dateNotificationModification)),
                            "rationale":  ($lastModif.objetModification),
                            "amendsReleaseID": ($releaseIdMeta.id + "-" + ($releaseIdMeta.seq | tonumber | . - 1 |
                            tostring | if length < 2 then "0" + . else . end)),
                            "releaseID": $releaseId
                            } ]
                        else null end),
                    "period":   {
                        "durationInDays": getDurationInDays($lastModif.dureeMois //
                        .dureeMois)
                    },
                    "status": (if $releaseIdMeta.nbModif > 0 then "active" else "pending" end),
                    "items": $items
                }
            ]
		} else null end
    ],
}
# Added to remove all null properties from the resulting tree
| walk(
    if type == "object" then
        with_entries(select( .value != null and .value != {} and .value != []))
    elif type == "array" then
        map(select( . != null and . != {} and . != []))
    else
        .
    end
)

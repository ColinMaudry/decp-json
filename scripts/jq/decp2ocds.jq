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
		"date": "2018-11-12T00:00:00Z",
		"tag": ["award"],
		"#comment": "awardUpdate if modifications non-null",
		"initiationType": "tender",
		"parties": [{
				"name": "VILLE DE CHOLET",
				"id": "21490099500017",
				"identifier": {
					"scheme": "FR-INSEE",
					"id": "21490099500017",
					"legalName": "VILLE DE CHOLET"
				},
				"roles": ["buyer"]
			},
			{
				"name": "ESVIA SAS",
				"id": "32902082000042",
				"identifier": {
					"scheme": "FR-INSEE",
					"id": "32902082000042",
					"legalName": "ESVIA SAS"
				},
				"roles": ["supplier"]
			}
		],
		"buyer": {
			"name": "VILLE DE CHOLET",
			"id": "21350051500019"
		},
		"awards": [{
			"id": "213500515000192018tet01",
			"description": "TRAVAUX DE SIGNALISATION VERTICALE ET HORIZONTALE ET POSE DE MOBILIER URBAIN 2018/2021",
			"status": "active",
			"date": "2018-10-04T00:00:00+02:00",
			"value": {
				"amount": 200000,
				"currency": "EUR"
			},
			"suppliers": [{
				"name": "ESVIA SAS",
				"id": "32902082000042"
			}],
			"items": [{
				"id": "1",
				"description": "TRAVAUX DE SIGNALISATION VERTICALE ET HORIZONTALE ET POSE DE MOBILIER URBAIN 2018/2021",
				"classification": {
					"scheme": "CPV",
					"id": "34942000-2"
				}
			}],
			"contractPeriod": {
				"startDate": "2018-10-04T00:00:00+02:00",
				"durationInDays": 366
			},
			"amendments": [{
				"#comment": "content of moficiations/modification (last, if any)"
			}]
		}],
		"language": "fr"
	}]
}

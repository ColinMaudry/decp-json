
def ceil(number):
    number |
    if (floor != . or . == 0)  then floor + 1 else . end ;
def fixDate(date):
    date |
    if (type == "string" and test("\\-\\d[\\-$]?")) then . |= split("-") | .[0] + "-" + if .[1] | length == 1 then ("0" + .[1]) else .[1] end + "-" + if (.[2] | length) == 1 then "0" + .[2] else .[2] end else . end;
def walk(f):
  . as $in
  | if type == "object" then
      reduce keys_unsorted[] as $key
        ( {}; . + { ($key):  ($in[$key] | walk(f)) } ) | f
  elif type == "array" then map( walk(f) ) | f
  else f
  end;

.marches[].montant |= if type == "string" then tonumber else . end |
.marches[].valeurGlobale |= if type == "string" then tonumber else . end |
.marches[].dureeMois |= if type == "string" then tonumber | ceil(.) else ceil(.) end |
.marches[].lieuExecution.code |= if type == "number" then tostring else . end |
.marches[].lieuExecution.nom |= if type == "number" then tostring else . end |
.marches[].id |= if type == "number" then tostring else . end |
.marches[].acheteur.id |= if type == "number" then tostring else . end |
.marches[].autoriteConcedante.id |= if type == "number" then tostring else . end |
.marches[].codeCPV |= if type == "number" then tostring else . end |
.marches[].titulaires |= if (type == "null") then null else .[].id |= tostring  end |
.marches[].titulaires |= if (type == "null") then null else .[].denominationSociale |= tostring  end |
.marches[].concessionnaires |= if (type == "null") then null else .[].id |= tostring  end |
.marches[].donneesExecution |= if (type != "array") then [] else . end |
.marches[].dateNotification |= fixDate(.) |
.marches[].modifications |= if (type == "array" and length > 0) then .[].dateNotificationModification |= fixDate(.) else . end |
.marches[] |= if ( .["_type"] | type == "null") then if has("acheteur") then .["_type"] |= "Marché" elif has("autoriteConcedante") then .["_type"] |= "Contrat de concession" else .["_type"] |= "?" end else . end |
.marches[].modifications |=
if (type == "array" and length > 0) then
.[].titulaires |=
    if (type == "array" and length > 0) then .[].id |= tostring else . end
else [] end

# Added to remove all null properties from the resulting tree
| walk(
    if type == "object" then
        with_entries(select( .value != null and .value != {} and .value != [] or .key == "modifications" or .key == "donneesExecution"))
    elif type == "array" then
        map(select( . != null and . != {} ))
    else
        .
    end
)

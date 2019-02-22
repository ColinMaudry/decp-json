
.marches[].montant |= if type == "string" then tonumber else . end |
.marches[].lieuExecution.code |= if type == "number" then tostring else . end |
.marches[].acheteur.id |= if type == "number" then tostring else . end |
.marches[].codeCPV |= if type == "number" then tostring else . end |
.marches[].titulaires |= if (type == "null") then null else .[].id |= tostring  end |
.marches[].concessionaires |= if (type == "null") then null else .[].id |= tostring  end

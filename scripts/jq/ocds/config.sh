#!/bin/bash

if [[ -z $datetime ]]
then
 export datetime=`date "+%FT%T+02:00"`
fi

export dataset_id="5d1a216e6f4441513e89b93e"
export package_uri="https://www.data.gouv.fr/fr/datasets/r/2a84ffc7-7121-48d2-a28f-85d835ed09a4"
export dataset_url="https://www.data.gouv.fr/fr/datasets/$dataset_id"
export ocid_prefix="ocds-78apv2"

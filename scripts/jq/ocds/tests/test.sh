#!/bin/bash
cd ../../../

export datetime=2019-01-01T01:01:01+02:00

for test in `ls scripts/jq/ocds/tests/source`
do
    echo "$test"
    scripts/makeOCDS.sh scripts/jq/ocds/tests/source/$test > result
    diff result scripts/jq/ocds/tests/expectedResult/$test
    echo ""
    echo "*******************"
done

rm result
export datetime=

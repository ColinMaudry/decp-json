#!/bin/bash

jq -s '{ marches: map(.marches[0]) }' *.json

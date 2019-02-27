#!/bin/bash

jq -s '{ marches: map(.marches[]) }' *.json

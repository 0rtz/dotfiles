#!/usr/bin/env bash

set -eu

free --total --human | awk '$1 ~ /:/ && FNR == 4 { printf "%s/%s", $3, $2 }'
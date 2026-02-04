#!/bin/bash

ram_available () {
	ALL=$(free --total --human | awk -e '$1 ~ /:/ && FNR == 4 {print $2}')
	USED=$(free --total --human | awk -e '$1 ~ /:/ && FNR == 4 {print $3}')
	echo "${USED}/${ALL}"
}

printf "%s" "$(ram_available)"
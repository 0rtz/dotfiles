#!/bin/sh

df "$PWD" --human-readable | awk ' NR==2 { print $3"/"$2 } '
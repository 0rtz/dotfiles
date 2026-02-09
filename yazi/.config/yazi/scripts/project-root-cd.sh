#!/usr/bin/env bash
# cd to the closest project root by searching upward for root patterns

ROOT_PATTERNS=".git _darcs .hg .bzr .svn package.json .root .marksman.toml"

dir="$PWD"
while [ "$dir" != "/" ]; do
	for pattern in $ROOT_PATTERNS; do
		if [ -e "$dir/$pattern" ]; then
			ya emit cd "$dir"
			exit 0
		fi
	done
	dir=$(dirname "$dir")
done

#!/bin/bash

FAILED=$(systemctl --quiet --failed | wc -l)
USER_FAILED=$(systemctl --quiet --user --failed | wc -l)
TOTAL=$((FAILED + USER_FAILED))

if [[ $TOTAL -gt 0 ]]; then
	printf '{"text": "(%s)", "tooltip": "User: %s\\nSystem: %s", "class": "failed"}\n' "$TOTAL" "$USER_FAILED" "$FAILED"
else
	printf '{"text": ""}\n'
fi

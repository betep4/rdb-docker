#!/bin/bash
set -e

if [[ -n "$ALIAS_DB" ]]; then
    python /alias.py "$ALIAS_DB"
fi

service xinetd start

$@

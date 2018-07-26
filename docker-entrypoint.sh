#!/bin/bash
set -e

if [[ -z "$SERVER_MODE" ]]; then
    SERVER_MODE="Super"
fi

if [[ -z "$AUTH_SERVER" ]]; then
    AUTH_SERVER="Legacy_Auth"
fi

if [[ -n "$ALIAS_DB" ]]; then
    python /alias.py "$ALIAS_DB"
fi

if [[ -z "$REMOTE_AUX_PORT" ]]; then
    REMOTE_AUX_PORT="6001"
fi

echo "Server mode: $SERVER_MODE, auth server: $AUTH_SERVER"

sed -i -e "s/^#ServerMode.*Super$/ServerMode = $SERVER_MODE/" /opt/RedDatabase/firebird.conf
sed -i -e "s/^#AuthServer = Srp$/AuthServer = $AUTH_SERVER/" /opt/RedDatabase/firebird.conf
sed -i -e "s/^#RemoteAuxPort = 0$/RemoteAuxPort = $REMOTE_AUX_PORT/" /opt/RedDatabase/firebird.conf

if [[ "$SERVER_MODE" = "Classic" ]]; then
    service xinetd start
else
    /opt/RedDatabase/bin/rdbguard -daemon
fi

$@

#!/bin/bash

JBOSS_HOME=/opt/jboss/keycloak/
JBOSS_CLI=$JBOSS_HOME/bin/jboss-cli.sh

set -m

function wait_for_server() {
  until `$JBOSS_CLI -c "ls /deployment" &> /dev/null`; do
    sleep 1
  done
}

echo "=> Starting keycloak server"
$JBOSS_HOME/bin/standalone.sh -b 0.0.0.0 -Dkeycloak.migration.action=import -Dkeycloak.migration.provider=singleFile -Dkeycloak.migration.file=/opt/jboss/keycloak/helloworldmsa.json -Dkeycloak.migration.strategy=OVERWRITE_EXISTING &

echo "=> Waiting for the server to boot"
wait_for_server

echo "=> Executing the commands"
/opt/jboss/register-clients.sh

echo "Returning keycloak to Foreground"
fg

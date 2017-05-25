#!/bin/bash
cd /opt/jboss/keycloak/bin/
./kcreg.sh config credentials --server http://localhost:8080/auth --realm master --user $KEYCLOAK_USER --password $KEYCLOAK_PASSWORD --client admin-cli
./kcreg.sh create --realm helloworld-msa -s publicClient=true -s clientId=frontend -s protocol=openid-connect -s "redirectUris=[\"http://frontend-${OS_PROJECT}.${OS_SUBDOMAIN}/*\"]" -s baseUrl=http://frontend-${OS_PROJECT}.${OS_SUBDOMAIN}  -s "webOrigins=[\"*\"]"

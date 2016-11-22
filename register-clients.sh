#!/bin/bash
/opt/jboss/keycloak/bin/kcreg.sh config credentials --server http://localhost:8080/auth --realm master --user $KEYCLOAK_USER --password $KEYCLOAK_PASSWORD --client admin-cli
/opt/jboss/keycloak/bin/kcreg.sh create --realm helloworld-msa -s publicClient=true -s clientId=hola -s protocol=openid-connect -s rootUrl=http://hola-${OS_PROJECT}.${OS_SUBDOMAIN} -s "redirectUris=[\"/*\"]" 


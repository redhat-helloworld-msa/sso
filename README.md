# sso
Repository for Keycloak - The SSO (Single Sign-On) server for these microservices
---

The detailed instructions to run Red Hat Helloworld MSA demo, can be found at the following repository: https://github.com/redhat-helloworld-msa/helloworld-msa

This Repository creates a container that starts KeyCloak. 

During the startup, the file `helloworldmsa.json` that containes the helloworld-msa Realm is imported.

The script register-clients.sh is also executed to create a client for the frontend. 

You can customize the frontend URL using the environent variables `$OS_SUBDOMAIN='rhel-cdk.10.1.2.2.xip.io' `and  `$OS_PROJECT='helloworld-msa'`

After the startup it used `$KEYCLOAK_USER` and `$KEYCLOAK_PASSWORD` environemtn variables to create the admin credentials.


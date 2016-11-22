FROM jboss/base-jdk:8

ENV KEYCLOAK_VERSION 2.3.0.Final
# Enables signals getting passed from startup script to JVM
# ensuring clean shutdown when container is stopped.
ENV LAUNCH_JBOSS_IN_BACKGROUND 1

ENV KEYCLOAK_USER admin
ENV KEYCLOAK_PASSWORD admin

# Variables that define default values for the OpenShift Project
# and the Openshift dynamic subdomain that is being used. These 
# values are used to build up the service URLs that are used for
# the services at runtime. These can also be overridden by injecting
# environment variables into the container at runtime.
ENV OS_SUBDOMAIN='rhel-cdk.10.1.2.2.xip.io' \
    OS_PROJECT='helloworld-msa'

USER root

RUN yum install -y epel-release && yum install -y jq && yum clean all

USER jboss

RUN cd /opt/jboss/ && curl -L https://downloads.jboss.org/keycloak/$KEYCLOAK_VERSION/keycloak-$KEYCLOAK_VERSION.tar.gz | tar zx && mv /opt/jboss/keycloak-$KEYCLOAK_VERSION /opt/jboss/keycloak

ADD helloworldmsa.json /opt/jboss/keycloak/
ADD register-clients.sh /opt/jboss/

ADD setLogLevel.xsl /opt/jboss/keycloak/
RUN java -jar /usr/share/java/saxon.jar -s:/opt/jboss/keycloak/standalone/configuration/standalone.xml -xsl:/opt/jboss/keycloak/setLogLevel.xsl -o:/opt/jboss/keycloak/standalone/configuration/standalone.xml

ENV JBOSS_HOME /opt/jboss/keycloak

EXPOSE 8080

ENTRYPOINT [ "/opt/jboss/keycloak/bin/standalone.sh" ]

CMD ["-b", "0.0.0.0", "-Dkeycloak.migration.action=import","-Dkeycloak.migration.provider=singleFile","-Dkeycloak.migration.file=/opt/jboss/keycloak/helloworldmsa.json","-Dkeycloak.migration.strategy=OVERWRITE_EXISTING"]
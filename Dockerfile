FROM fabric8/java-jboss-openjdk8-jdk:1.3.1

ENV KEYCLOAK_VERSION 3.1.0.Final
# Enables signals getting passed from startup script to JVM
# ensuring clean shutdown when container is stopped.
ENV LAUNCH_JBOSS_IN_BACKGROUND 1

ENV KEYCLOAK_USER admin
ENV KEYCLOAK_PASSWORD admin
ENV PROXY_ADDRESS_FORWARDING true
ENV JBOSS_HOME /opt/jboss/keycloak

# Variables that define default values for the OpenShift Project
# and the Openshift dynamic subdomain that is being used. These 
# values are used to build up the service URLs that are used for
# the services at runtime. These can also be overridden by injecting
# environment variables into the container at runtime.
ENV OS_SUBDOMAIN='rhel-cdk.10.1.2.2.xip.io' \
    OS_PROJECT='helloworld-msa'

USER root

RUN yum install -y epel-release && yum install -y jq && yum clean all

RUN cd /opt/jboss/ && curl -L https://downloads.jboss.org/keycloak/$KEYCLOAK_VERSION/keycloak-$KEYCLOAK_VERSION.tar.gz | tar zx && mv /opt/jboss/keycloak-$KEYCLOAK_VERSION /opt/jboss/keycloak

# Run under user "jboss" and prepare for be running
# under OpenShift, too
RUN chown -R jboss $JBOSS_HOME \
 && usermod -g root -G `id -g jboss` jboss \
 && chmod -R "g+rwX" $JBOSS_HOME \
 && chown -R jboss:root $JBOSS_HOME

USER jboss

ADD helloworldmsa.json /opt/jboss/keycloak/
ADD execute.sh /opt/jboss/keycloak/bin/
ADD register-clients.sh /opt/jboss/

ADD setLogLevel.xsl /opt/jboss/keycloak/
RUN java -jar /usr/share/java/saxon.jar -s:/opt/jboss/keycloak/standalone/configuration/standalone.xml -xsl:/opt/jboss/keycloak/setLogLevel.xsl -o:/opt/jboss/keycloak/standalone/configuration/standalone.xml


#Enabling Proxy address forwarding so we can correctly handle SSL termination in front ends
#such as an OpenShift Router or Apache Proxy
RUN sed -i -e 's/<http-listener /& proxy-address-forwarding="${env.PROXY_ADDRESS_FORWARDING}" /' $JBOSS_HOME/standalone/configuration/standalone.xml


EXPOSE 8080

CMD [ "/opt/jboss/keycloak/bin/execute.sh" ]
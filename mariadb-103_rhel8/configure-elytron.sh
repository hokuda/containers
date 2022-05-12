#!/bin/sh

FILE="/usr/lib/java/mariadb-java-client.jar"
if test -f "$FILE"; then
    echo "$FILE exist"
else
    echo "run `dnf install mariadb-java-client`"
    exit
fi

$JBOSS_HOME/bin/jboss-cli.sh << EOF
embed-server --std-out=echo --server-config=standalone.xml
module add --name=org.mariadb.jdbc --resources=$FILE --dependencies=javax.api,javax.transaction.api
/subsystem=datasources/jdbc-driver=mariadb:add(driver-module-name="org.mariadb.jdbc", driver-name="mariadb", driver-xa-datasource-class-name="org.mariadb.jdbc.MariaDbDataSource")
/subsystem=datasources/data-source=mariadb:add(jndi-name="java:jboss/datasources/mariadb", use-java-context=true,connection-url="jdbc:mariadb://localhost:3306/eap7",driver-name="mariadb",user-name="mariadb",password="password")
stop-embedded-server
embed-server --std-out=echo --server-config=standalone.xml
/subsystem=elytron/jdbc-realm=exampleDbRealm:add(principal-query=[ \
    { \
        sql="SELECT password FROM USERS WHERE username=?", \
        data-source=mariadb, \
        clear-password-mapper={password-index=1}, \
    }, \
    { \
        sql="SELECT rolename FROM ROLES WHERE username=?", \
        data-source=mariadb, \
        attribute-mapping=[{index=1,to=groups}] \
    } \
])
/subsystem=elytron/security-domain=exampleDbSD:add(realms=[{realm=exampleDbRealm,role-decoder=groups-to-roles}],default-realm=exampleDbRealm,permission-mapper=default-permission-mapper)
/subsystem=elytron/http-authentication-factory=example-db-http-auth:add(http-server-mechanism-factory=global,security-domain=exampleDbSD,mechanism-configurations=[{mechanism-name=BASIC,mechanism-realm-configurations=[{realm-name=exampleDbSD}]}])
/subsystem=undertow/application-security-domain=exampleApplicationDomain:add(http-authentication-factory=example-db-http-auth)
stop-embedded-server
EOF

#!/bin/sh

FILE="/usr/lib/java/mariadb-java-client.jar"
if test -f "$FILE"; then
    echo "$FILE exist"
else
    echo "run `dnf install mariadb-java-client`"
    exit
fi

$JBOSS_HOME/bin/jboss-cli.sh << EOF
embed-server --std-out=echo --server-config=standalone-ha.xml
module add --name=org.mariadb.jdbc --resources=$FILE --dependencies=javax.api,javax.transaction.api
/subsystem=datasources/jdbc-driver=mariadb:add(driver-module-name="org.mariadb.jdbc", driver-name="mariadb", driver-xa-datasource-class-name="org.mariadb.jdbc.MySQLDataSource")
/subsystem=datasources/data-source=mariadb:add(jndi-name="java:jboss/datasources/mariadb", use-java-context=true,connection-url="jdbc:mysql://localhost:3306/rhsso",driver-name="mariadb",user-name="mariadb",password="password")
xa-data-source add --name=mariadb-xa --jndi-name=java:/jboss/datasources/mariadb-xa --driver-name=mariadb --xa-datasource-properties={"ServerName"=>"localhost","DatabaseName"=>"rhsso"} --user-name=mariadb --password=password
/subsystem=keycloak-server/spi=connectionsJpa/provider=default:write-attribute(name=properties.dataSource, value=java:jboss/datasources/mariadb-xa)
stop-embedded-server
EOF

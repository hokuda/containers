#!/bin/sh

FILE="/usr/share/java/mysql-connector-java.jar"
if test -f "$FILE"; then
    echo "$FILE exist"
else
    echo "run `dnf install mysql-connector-java.noarch`"
    exit
fi

$JBOSS_HOME/bin/jboss-cli.sh << EOF
embed-server --std-out=echo --server-config=standalone-ha.xml
module add --name=org.mysql.jdbc --resources=$FILE --dependencies=javax.api,javax.transaction.api
/subsystem=datasources/jdbc-driver=mysql:add(driver-module-name="org.mysql.jdbc", driver-name="mysql", driver-xa-datasource-class-name="com.mysql.cj.jdbc.MysqlXADataSource")
/subsystem=datasources/data-source=mariadb:add(jndi-name="java:jboss/datasources/mysql", use-java-context=true,connection-url="jdbc:mysql://localhost:3306/rhsso",driver-name="mysql",user-name="root",password="password")
xa-data-source add --name=mysql-xa --jndi-name=java:/jboss/datasources/mysql-xa --driver-name=mysql --xa-datasource-properties={"ServerName"=>"localhost","DatabaseName"=>"rhsso"} --user-name=root --password=password
/subsystem=keycloak-server/spi=connectionsJpa/provider=default:write-attribute(name=properties.dataSource, value=java:jboss/datasources/mysql-xa)
stop-embedded-server
EOF

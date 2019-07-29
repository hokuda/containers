A sample web application protected with Elytron LDAP seurity

- how to deploy

```
docker cp openldap-rhel7:/etc/openldap/certs/cert.pem .
keytool -noprompt -importcert -keystore trust.jks -storepass password -alias ca -trustcacerts -file cert.pem
cp trust.jks $JBOSS_HOME/standalone/configuration/
$JBOSS_HOME/bin/jboss-cli.sh -c --file=./basic/configure-elytron-ldap-basic.cli
cd basic/sample/
mvn install
cp ./target/sample.war $JBOSS_HOME/standalone/deployments/
```

- how to enjoy

  Access http://localhost:8080/sample/
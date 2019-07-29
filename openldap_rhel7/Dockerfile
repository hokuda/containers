FROM registry.access.redhat.com/rhel7
RUN yum-config-manager --disable rhel-7-server-htb-rpms
RUN yum -y install openldap-servers openldap-clients openssl net-tools
RUN cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
RUN chown ldap. /var/lib/ldap/DB_CONFIG

RUN openssl req -new -x509 -nodes -out /etc/openldap/certs/cert.pem -keyout /etc/openldap/certs/key.pem -days 3650 -subj /CN=localhost
RUN chown ldap:ldap /etc/openldap/certs/*
RUN chmod 600 /etc/openldap/certs/key.pem
RUN chown ldap:ldap /var/lib/ldap/*

RUN sed 's/\(olcTLSCertificateFile:\) .*/\1 \/etc\/openldap\/certs\/cert.pem/' /etc/openldap/slapd.d/cn\=config.ldif > /etc/openldap/slapd.d/cn\=config.ldif.1
RUN sed 's/\(olcTLSCertificateKeyFile:\) .*/\1 \/etc\/openldap\/certs\/key.pem/' /etc/openldap/slapd.d/cn\=config.ldif.1 > /etc/openldap/slapd.d/cn\=config.ldif
RUN rm -f /etc/openldap/slapd.d/cn\=config.ldif.1

#RUN echo "dn: cn=config" > /config.ldif
#RUN echo "changetype: modify" >> /config.ldif
#RUN echo "replace: olcTLSCertificateFile" >> /config.ldif
#RUN echo "olcTLSCertificateFile: /etc/openldap/certs/cert.pem" >> /config.ldif
#RUN echo "" >> /config.ldif
#RUN echo "dn: cn=config" > /config.ldif
#RUN echo "changetype: modify" >> /config.ldif
#RUN echo "replace: olcTLSCertificateKeyFile" >> /config.ldif
#RUN echo "olcTLSCertificateKeyFile: /etc/openldap/certs/key.pem" >> /config.ldif
#RUN echo "" >> /config.ldif

RUN echo $'\
dn: olcDatabase={2}hdb,cn=config\n\
changetype: modify\n\
replace: olcSuffix\n\
olcSuffix: dc=redhat,dc=com\n\
\n\
dn: olcDatabase={2}hdb,cn=config\n\
changetype: modify\n\
replace: olcRootDN\n\
olcRootDN: cn=Manager,dc=redhat,dc=com\n\
\n\
dn: olcDatabase={2}hdb,cn=config\n\
changetype: modify\n\
add: olcRootPW\n\
olcRootPW: password\n\
\n\
dn: cn=config\n\
changetype: modify\n\
add: olcLogLevel\n\
olcLogLevel: 256\n\
\n' > /config.ldif


RUN echo $'\
dn: dc=redhat,dc=com\n\
objectClass: top\n\
objectClass: dcObject\n\
objectclass: organization\n\
o: redhat\n\
dc: redhat\n\
\n\
dn: ou=people,dc=redhat,dc=com\n\
objectClass: organizationalUnit\n\
ou: people\n\
\n\
dn: ou=group,dc=redhat,dc=com\n\
objectClass: organizationalUnit\n\
ou: group\n\
\n\
dn: uid=user1,ou=people,dc=redhat,dc=com\n\
objectClass: organizationalPerson\n\
objectClass: inetOrgPerson\n\
givenName:: 5aSq6YOO\n\
ou:: 57WM55CG6YOo\n\
o:: WFjkvJrnpL4=\n\
title: manager\n\
street:: 5p2x5Lqs6YO95riL6LC35Yy6\n\
mail: user1@redhat.com\n\
telephoneNumber: 0120-266-668\n\
sn:: dGVzdCBzcGFjZSB0ZXN0IA==\n\
userPassword:: cGFzc3dvcmQ=\n\
uid: user1\n\
cn: user1\n\
\n\
dn: uid=user2,ou=people,dc=redhat,dc=com\n\
objectClass: organizationalPerson\n\
objectClass: inetOrgPerson\n\
givenName:: 5aSq6YOO\n\
ou:: 57WM55CG6YOo\n\
o:: WFjkvJrnpL4=\n\
title: manager\n\
street:: 5p2x5Lqs6YO95riL6LC35Yy6\n\
mail: user2@redhat.com\n\
telephoneNumber: 0120-266-668\n\
sn:: dGVzdCBzcGFjZSB0ZXN0IA==\n\
userPassword:: cGFzc3dvcmQ=\n\
uid: user2\n\
cn: user2\n\
\n\
dn: cn=admin,ou=Group,dc=redhat,dc=com\n\
objectClass: groupOfNames\n\
cn: admin\n\
member: uid=user1,ou=people,dc=redhat,dc=com\n\
\n\
dn: cn=guest,ou=Group,dc=redhat,dc=com\n\
objectClass: groupOfNames\n\
cn: admin\n\
member: uid=user2,ou=people,dc=redhat,dc=com\n\
' >> /entries.ldif

RUN echo "#!/bin/bash" > /run.sh
RUN echo "/config.sh&" >> /run.sh
RUN echo "/usr/sbin/slapd -h \"ldapi:/// ldap:/// ldaps:///\" -u ldap -d 256" >> /run.sh

RUN echo "#!/bin/bash" > /config.sh
RUN echo $'\
while true\n\
do\n\
echo "waiting for openldap started"\n\
sleep 1\n\
ldapsearch -Y EXTERNAL -H ldapi:/// -b cn=config 2>&1 > /dev/null\n\
if [ "$?" = "0" ]; then\n\
break\n\
fi\n\
done\n\
ldapadd -Y EXTERNAL -H ldapi:/// -f /config.ldif\n\
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif\n\
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif\n\
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif\n\
ldapadd -D cn=Manager,dc=redhat,dc=com -w password -f /entries.ldif\n\
' >> /config.sh

#
#ldasearch -D cn=Manager,dc=redhat,dc=com -w password -b dc=redhat,dc=com\n\

RUN chmod +x /run.sh
RUN chmod +x /config.sh

CMD ["/run.sh"]
#CMD ['/usr/sbin/slapd -h \"ldapi:/// ldap:/// ldaps:///\" -u ldap -d 256']
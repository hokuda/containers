FROM registry.redhat.io/ubi8/ubi-init
RUN yum install vim less net-tools selinux-policy-targeted httpd mod_auth_mellon php openssl unzip -y
RUN mkdir /etc/httpd/saml
RUN /usr/libexec/mod_auth_mellon/mellon_create_metadata.sh http://www.sp.org:10080/sp http://www.sp.org:10080/mellon
RUN mv http_www.sp.org_10080_sp.key /etc/httpd/saml
RUN mv http_www.sp.org_10080_sp.cert /etc/httpd/saml
RUN mv http_www.sp.org_10080_sp.xml /etc/httpd/saml
RUN echo $'\
<Location />\n\
  MellonEndpointPath "/mellon"\n\
  MellonIdPMetadataFile /etc/httpd/saml/idp-metadata.xml\n\
  MellonSPPrivateKeyFile /etc/httpd/saml/http_www.sp.org_10080_sp.key\n\
  MellonSPCertFile /etc/httpd/saml/http_www.sp.org_10080_sp.cert\n\
  MellonSPMetadataFile /etc/httpd/saml/http_www.sp.org_10080_sp.xml\n\
</Location>\n\
<Location /protected>\n\
  AuthType "Mellon"\n\
  Require valid-user\n\
  MellonEnable "auth"\n\
</Location>\n' >> /etc/httpd/conf.d/auth_mellon.conf
RUN mkdir /var/www/html/protected
RUN echo $'\
<?php\n\
phpinfo();\n\
?>\n' >> /var/www/html/protected/phpinfo.php

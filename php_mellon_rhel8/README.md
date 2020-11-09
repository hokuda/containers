# php + mod_auth_mellon on Apache httpd

* change /etc/hosts as follows adding www.idp.org and www.sp.org

```
$ cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4 www.idp.org www.sp.org idp.org rp.org
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
```

* build an image and run a container

```
$ podman login -u <username> https://registry.redhat.io
$ ./start-php_mellon.sh
```

* copy sp-metadata to the host

```
$ podman cp php_mellon_httpd_container:/etc/httpd/saml/http_www.sp.org_10080_sp.xml .
```

* start rh-sso, and login rh-sso console (note that you need to access the console with the hostname www.idp.org, ie, http://www.idp.org:8080/auth so that the metadata is created properly)

* create the realm "idp" in rh-sso

* create the client using http_www.sp.org_10080_sp.xml (set http://www.sp.org:10080/mellon to Client SAML Endpoint)

* create the idp metadata:
  * goto Clients > http://www.sp.org:10080/sp > Installation
  * select Mod Auth Mellon files, and save the zip file

* unzip keycloak-mod-auth-mellon-sp-config.zip and copy idp-metadata.xml to the container
```
podman cp idp-metadata.xml php_mellon_httpd_container:/etc/httpd/saml
```

* start httpd
```
$ podman exec -it php_mellon_httpd_container /usr/bin/systemctl start httpd
```

* access http://www.sp.org:10080/protected/phpinfo.php

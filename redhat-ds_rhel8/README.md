# Red Hat Directory Server container

* build an image and run redhat-ds

```
podman login -u <username> https://registry.redhat.io
```

```
./start-redhat-ds.sh
```

* view log

```
podman exec -it redhat-ds tail -f  /var/log/dirsrv/slapd-localhost/access
```

* ldap test

```
ldapsearch -v -x -H ldap://localhost:10389/ -D "cn=Directory Manager" -w password -s sub -b ou=people,dc=redhat,dc=com dn cn
```

* ldap test with LDAP+StartTLS

Disable certificate verification:
```
$ sudo vim /etc/openldap/ldap.conf
TLS_REQCERT never
```

```
$ ldapsearch -ZZ -v -x -H ldap://localhost:10389/ -D "cn=Directory Manager" -w password -s sub -b dc=redhat,dc=com "uid=demo_user" cn
```

* ldap test with LDAPS

```
$ ldapsearch -v -x -H ldaps://localhost:10636/ -D "cn=Directory Manager" -w password -s sub -b dc=redhat,dc=com "uid=demo_user" cn
```


The admin URL is http://localhost:19090/ to log in as root/password.

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

The admin URL is http://localhost:19090/ to log in as root/password.
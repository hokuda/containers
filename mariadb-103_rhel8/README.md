# mariadb container with query logging

* add the following line to /etc/subuid and /etc/subgid before running a container

```
mariadb:100000:65536
```

* build an image and run mariadb

```
podman login -u <username> https://registry.redhat.io
```

```
./run-mariadb.sh
```

* view log

```
podman logs -f mariadb_rhsso730 to see the query log # to view query log
```

* run mariadb client

```
mysql -u mariadb --password=password --host=localhost --protocol=TCP rhsso73x
```

* install mariadb jdbc driver

```
dnf install mariadb-java-client
```

* configure RH-SSO

```
./configure-datasource.sh
```
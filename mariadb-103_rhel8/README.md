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

Notes:
When you see:

```
Error: error creating build container: Error committing the finished image: error adding layer with blob "sha256:71391dc11a78542160544b68e45bc123ff55a2e84aeb6fa99b672d75765bc2f8": Error processing tar file(exit status 1): there might not be enough IDs available in the namespace (requested 1001:0 for /opt/app-root): lchown /opt/app-root: invalid argument
```

run:

```
podman system migrate
```

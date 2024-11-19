# PostgreSQL on RHEL9

* build an image and run mariadb

```
podman login -u <username> https://registry.redhat.io
```

```
./run-postgresql.sh
```

* view log

```
$ podman exec -it postgresql_keycloak tail -f /var/lib/pgsql/data/userdata/log/postgresql-Mon.log
```

* run psql

```
$ psql -h localhost -U keycloak -W keycloak
keycloak=> # list db
keycloak-> \l
                                                      List of databases
   Name    |  Owner   | Encoding | Locale Provider |  Collate   |   Ctype    | ICU Locale | ICU Rules |   Access privileges   
-----------+----------+----------+-----------------+------------+------------+------------+-----------+-----------------------
 keycloak  | keycloak | UTF8     | libc            | en_US.utf8 | en_US.utf8 |            |           | 
 postgres  | postgres | UTF8     | libc            | en_US.utf8 | en_US.utf8 |            |           | 
 template0 | postgres | UTF8     | libc            | en_US.utf8 | en_US.utf8 |            |           | =c/postgres          +
           |          |          |                 |            |            |            |           | postgres=CTc/postgres
 template1 | postgres | UTF8     | libc            | en_US.utf8 | en_US.utf8 |            |           | =c/postgres          +
           |          |          |                 |            |            |            |           | postgres=CTc/postgres
(4 rows)

keycloak=> create table test (a varchar(16), b varchar(16));
CREATE TABLE
keycloak=> \d
 public | test | table | keycloak

keycloak=> \d test
 a      | character varying(16) |           |          | 
 b      | character varying(16) |           |          | 
 
keycloak=> insert into test values('xxx', 'yyy');
INSERT 0 1
keycloak=> select * from test;
  a  |  b  
-----+-----
 xxx | yyy
(1 row)

```

Note: password is password

* install postgresql jdbc driver

```
TBD
```

* configure RHBK24

```
cp keycloak.conf $RHBK_HOME/conf/
cd $RHBK_HOME
./bin/kc.sh start-dev
```

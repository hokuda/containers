#!/bin/bash

USER=mysql
PASSWORD=password
DATABASE=rhsso
CONTAINERNAME=mysql_$DATABASE
TAG=5.7

# reference: https://qiita.com/suin/items/95f15649a3ac39c8e9fb

podman build -t localhost/debian/mysql-query-log .

#podman run -d -v ./conf.d:/etc/mysql/conf.d --name $CONTAINERNAME -e MYSQL_ROOT_PASSWORD=$PASSWORD -e MYSQL_USER=$USER -e MYSQL_PASSWORD=$PASSWORD -e MYSQL_DATABASE=$DATABASE -p 3306:3306 docker.io/library/mysql:$TAG
#podman run --user 1000:1000 -d -v ./conf.d:/etc/mysql/conf.d --name $CONTAINERNAME -e MYSQL_ROOT_PASSWORD=$PASSWORD -e MYSQL_USER=$USER -e MYSQL_PASSWORD=$PASSWORD -e MYSQL_DATABASE=$DATABASE -p 3306:3306 docker.io/library/mysql:$TAG
#podman run --privileged -d -v ./conf.d:/etc/mysql/conf.d --name $CONTAINERNAME -e MYSQL_ROOT_PASSWORD=$PASSWORD -e MYSQL_USER=$USER -e MYSQL_PASSWORD=$PASSWORD -e MYSQL_DATABASE=$DATABASE -p 3306:3306 docker.io/library/mysql:$TAG /sbin/init
#podman run -d -v ./conf.d:/etc/mysql/conf.d --name $CONTAINERNAME -e MYSQL_ROOT_PASSWORD=$PASSWORD -e MYSQL_DATABASE=$DATABASE -p 3306:3306 docker.io/library/mysql:$TAG
#podman run -d --name $CONTAINERNAME -e MYSQL_ROOT_PASSWORD=$PASSWORD -e MYSQL_DATABASE=$DATABASE -p 3306:3306 docker.io/library/mysql:$TAG
podman run -d --name $CONTAINERNAME -e MYSQL_ROOT_PASSWORD=$PASSWORD -e MYSQL_DATABASE=$DATABASE -p 3306:3306 localhost/debian/mysql-query-log

echo
echo "cli template:"
echo
echo "view query log:"
echo "podman exec -it $CONTAINERNAME tail -f /var/log/mysql/query.log"
echo
echo "myql cli:"
echo "mysql -u root --password=$PASSWORD --host=localhost --protocol=TCP $DATABASE"
echo
echo "remove container:"
echo "podman rm -f $CONTAINERNAME"

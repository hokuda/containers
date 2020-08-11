USER=mariadb
PASSWORD=password
DATABASE=rhsso73x
CONTAINERNAME=mariadb_$DATABASE

# reference: https://qiita.com/suin/items/95f15649a3ac39c8e9fb

podman build -t localhost/fedora/mariadb-query-log .

podman run -d --name $CONTAINERNAME -e MYSQL_ROOT_PASSWORD=password -e MYSQL_USER=$USER -e MYSQL_PASSWORD=$PASSWORD -e MYSQL_DATABASE=$DATABASE -p 3306:3306 localhost/fedora/mariadb-query-log

echo "run podman logs -f $CONTAINERNAME to see the query log"

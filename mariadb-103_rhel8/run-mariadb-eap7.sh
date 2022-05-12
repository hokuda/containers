USER=mariadb
PASSWORD=password
DATABASE=eap7
CONTAINERNAME=mariadb_$DATABASE

# reference: https://qiita.com/suin/items/95f15649a3ac39c8e9fb

podman build -t localhost/fedora/mariadb-query-log .

podman run -d --name $CONTAINERNAME -e MYSQL_ROOT_PASSWORD=password -e MYSQL_USER=$USER -e MYSQL_PASSWORD=$PASSWORD -e MYSQL_DATABASE=$DATABASE -p 3306:3306 localhost/fedora/mariadb-query-log

echo "run podman logs -f $CONTAINERNAME to see the query log"

echo wait until mariadb gets started
for i in 1 2 3 4 5 6 7 8 9 0
do
    echo -n $i
    mysqladmin ping  -u mariadb --password=password --host=localhost --protocol=TCP >/dev/null 2>/dev/null
    if [ "$?" == "0" ]
    then
        echo
        break
    fi
    sleep 1
done

mysql -u mariadb --password=password --host=localhost --protocol=TCP eap7 -e "create table USERS(username varchar(16), password varchar(16))"
mysql -u mariadb --password=password --host=localhost --protocol=TCP eap7 -e "insert into USERS (username, password) values('user1', 'password')"
mysql -u mariadb --password=password --host=localhost --protocol=TCP eap7 -e "insert into USERS (username, password) values('user2', 'password')"

mysql -u mariadb --password=password --host=localhost --protocol=TCP eap7 -e "create table ROLES(rolename varchar(16), username varchar(16))"
mysql -u mariadb --password=password --host=localhost --protocol=TCP eap7 -e "insert into ROLES (rolename, username) values('admin', 'user1')"
mysql -u mariadb --password=password --host=localhost --protocol=TCP eap7 -e "insert into ROLES (rolename, username) values('guest', 'user2')"

mysql -u mariadb --password=password --host=localhost --protocol=TCP eap7 -e "select * from USERS;"
mysql -u mariadb --password=password --host=localhost --protocol=TCP eap7 -e "select * from ROLES;"

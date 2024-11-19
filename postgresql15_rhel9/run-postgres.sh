#!/bin/bash -v

USER=keycloak
PASSWORD=password
DATABASE=keycloak
CONTAINERNAME=postgresql_$DATABASE
IMAGE=localhost/rhel9/postgresql15

echo $USER
echo $PASSWORD
echo $DATABASE
echo $CONTAINERNAME
# reference: https://qiita.com/suin/items/95f15649a3ac39c8e9fb

podman build -t $IMAGE .

podman network create --subnet 10.1.0.0/24 podman-network1

echo "podman run --replace -d --name $CONTAINERNAME -e POSTGRESQL_USER=$USER -e POSTGRESQL_PASSWORD=$PASSWORD -e POSTGRESQL_DATABASE=$DATABASE -p 5432:5432 $IMAGE"

podman run --network podman-network1 --ip 10.1.0.253 -d --name $CONTAINERNAME -e POSTGRESQL_USER=$USER -e POSTGRESQL_PASSWORD=$PASSWORD -e POSTGRESQL_DATABASE=$DATABASE -p 5432:5432 $IMAGE

#echo "run podman logs -f $CONTAINERNAME"

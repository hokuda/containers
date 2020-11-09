#!/bin/sh
IMAGE_NAME=php_mellon_httpd/rhel8
CONTAINER_NAME=php_mellon_httpd_container
HTTP_PORT=10080

podman build -t $IMAGE_NAME .
podman run -d --privileged --name $CONTAINER_NAME -p $HTTP_PORT:80 localhost/$IMAGE_NAME /sbin/init
#podman exec -it $CONTAINER_NAME systemctl start cockpit.socket
#podman exec -it $CONTAINER_NAME dscreate -v from-file /root/dscreate.inf

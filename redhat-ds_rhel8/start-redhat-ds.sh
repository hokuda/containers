#!/bin/sh
IMAGE_NAME=redhat-ds/rhel8
CONTAINER_NAME=redhat-ds
LDAP_PORT=10389
LDAPS_PORT=10636
ADMIN_PORT=19090

podman build -t $IMAGE_NAME .
podman run -d --privileged --name $CONTAINER_NAME -p $LDAP_PORT:389 -p $LDAPS_PORT:636 -p $ADMIN_PORT:9090 localhost/$IMAGE_NAME /sbin/init
podman exec -it $CONTAINER_NAME systemctl start cockpit.socket
podman exec -it $CONTAINER_NAME dscreate -v from-file /root/dscreate.inf
podman exec -it $CONTAINER_NAME dsconf -D "cn=Directory Manager" -w password ldap://localost config replace nsslapd-securePort=636 nsslapd-security=on
podman exec -it $CONTAINER_NAME dsconf -D "cn=Directory Manager" -w password ldap://localhost security certificate list
podman exec -it $CONTAINER_NAME dsconf -D "cn=Directory Manager" -w password ldap://localhost security rsa set --tls-allow-rsa-certificates on --nss-token "internal (software)" --nss-cert-name Server-Cert
podman exec -it $CONTAINER_NAME dsctl slapd-localhost restart

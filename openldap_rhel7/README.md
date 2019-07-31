* openldap docker container

  -- usage

```
    docker build -t openldap/rhel7 .
    docker run -it --name openldap-rhel7 -p 1389:389 -p 1636:636 --log-driver=journald openldap/rhel7
```

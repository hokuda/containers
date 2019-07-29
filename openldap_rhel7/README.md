* openldap docker container

** usage

    docker build -t openldap/rhel7 .
    docker run -it -p 1389:389 --log-driver=journald openldap/rhel7

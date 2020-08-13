FROM registry.redhat.io/ubi8/ubi-init
RUN yum install vim less net-tools selinux-policy-targeted -y
RUN yum module install redhat-ds:11 --enablerepo dirsrv-11-for-rhel-8-x86_64-rpms -y
RUN dscreate create-template /root/dscreate.inf
RUN sed -i 's/\;root_password = Directory_Manager_Password/root_password = password/' /root/dscreate.inf
RUN sed -i 's/\;create_suffix_entry = False/create_suffix_entry = True/' /root/dscreate.inf
RUN sed -i 's/\;sample_entries = no/sample_entries = yes/' /root/dscreate.inf
RUN sed -i 's/\;suffix = /suffix = dc=redhat,dc=com/' /root/dscreate.inf
#RUN sed -i 's/\;secure_port = 636/secure_port = 10636/' /root/dscreate.inf
#RUN sed -i 's/\;selinux = True/selinux = False/' /root/dscreate.inf
#RUN sed -i 's/\;start = True/start = False/' /root/dscreate.inf
#RUN sed -i 's/\;systemd = True/systemd = False/' /root/dscreate.inf
#RUN dscreate -v from-file /root/dscreate.inf; exit 0
#RUN systemctl enable dirsrv@localhost
#RUN systemctl enable cockpit.socket
RUN echo "password" | passwd --stdin root
#CMD dscreate -v from-file /root/dscreate.inf

FROM jrei/systemd-ubuntu:22.04

RUN apt-get update && apt-get install -y krb5-kdc krb5-admin-server ldap-utils

COPY Initiate.sh /Initiate.sh
RUN chmod +x /Initiate.sh

ENTRYPOINT ["/Initiate.sh"]

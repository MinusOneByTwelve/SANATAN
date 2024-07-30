FROM debian:buster

RUN apt-get update && apt-get install -y krb5-kdc krb5-admin-server ldap-utils

COPY Initiate.sh /Initiate.sh
RUN chmod +x /Initiate.sh

EXPOSE 88 749

ENTRYPOINT ["/Initiate.sh"]


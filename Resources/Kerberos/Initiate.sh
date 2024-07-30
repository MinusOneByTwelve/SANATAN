#!/bin/bash

set -e

if [ ! -f /var/lib/krb5kdc/principal ]; then
    /usr/sbin/kdb5_util create -s -P "${KERB_PASSWD}"
fi

# Start krb5kdc and kadmind in the background
/usr/sbin/krb5kdc
/usr/sbin/kadmind

tail -f /dev/null

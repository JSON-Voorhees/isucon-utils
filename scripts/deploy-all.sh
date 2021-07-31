#!/bin/bash -e

. settings.sh

for host in ${ALL_HOSTS}
do
    scp ${SSH_OPTION} ./* ${SSH_USER}@${host}:~
    ssh ${SSH_OPTION} ${SSH_USER}@${host} bash deploy.sh
done
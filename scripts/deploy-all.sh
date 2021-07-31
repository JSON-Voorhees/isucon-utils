#!/bin/bash -e

echo "start deploy" | notify_slack

. settings.sh

for host in ${ALL_HOSTS}
do
    scp ${SSH_OPTION} ./* ${SSH_USER}@${host}:~
    ssh ${SSH_OPTION} ${SSH_USER}@${host} ./deploy.sh
done

echo "finish deploy" | notify_slack
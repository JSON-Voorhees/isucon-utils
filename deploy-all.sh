#!/bin/bash

set -ex

B=${1:-main}

SERVERS="isu1 isu2 isu3"
WEBAPP_DIR=/home/isucon/webapp

for s in ${SERVERS}; do
    ssh ${s} "cd ${WEBAPP_DIR}; make deploy B=${B}" &
done

wait

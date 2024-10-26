#!/bin/bash

set -ex

SERVERS="isu1 isu2 isu3"
WEBAPP_DIR=~/webapp

for s in ${SERVERS}; do
    ssh ${s} "cd ${WEBAPP_DIR}; make deploy" &
done

wait

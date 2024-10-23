#!/bin/bash

repo=$1

if [ -z "${repo}" ]; then
    echo "usage: ./create-gh-repo.sh repo"
fi

gh repo create ${repo} --private 

# デプロイキーを作成して ansible のディレクトリに配置する
SCRIPT_DIR=$(cd $(dirname $0); pwd)
KEY_DIR="${SCRIPT_DIR}/ansible/roles/ssh/files/deploy_keys/${repo}"
mkdir -p ${KEY_DIR}
ssh-keygen -t ed25519 -N "" -C "deploy key" -f ${KEY_DIR}/id_ed25519

gh repo deploy-key add ${KEY_DIR}/id_ed25519.pub -w --repo ${repo}

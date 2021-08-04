#!/bin/bash -xe

# load settings
. settings.sh

# util function
# usage: contains "space separated hosts" "serch_host"
contains() {
    set +x
    for x in ${1}; do
        if [[ ${x} = ${2} ]]; then
            set -x
            return 0
        fi
    done
    set -x
    return 1
}

echo $(hostname)

# for all hosts, git pull
git -C ${REPO_PATH} pull origin master || git clone ${REPO_URL} ${REPO_PATH}


if contains "${MYSQL_HOSTS}" $(hostname); then
    echo "Deploy mysql"
    sudo truncate -s 0 ${MYSQL_SLOW_QUERY_LOG_PATH}
    sudo systemctl restart mysql
fi

if contains "${NGINX_HOSTS}" $(hostname); then
    echo "Deploy nginx"
    sudo truncate -s 0 ${NGINX_LOG_PATH}
    sudo systemctl restart nginx
fi

if contains "${APACHE_HOSTS}" $(hostname); then
    echo "Deploy apache"
    sudo truncate -s 0 ${APACHE_LOG_PATH}
    sudo systemctl restart httpd
fi

if contains "${APP_HOSTS}" $(hostname); then
    echo "Deploy app"
    eval ${APP_BUILD_COMMAND}
    sudo systemctl restart ${APP_SERVICE_NAME}
fi

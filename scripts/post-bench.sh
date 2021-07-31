#!/bin/bash -xe

echo "start post-bench" | notify_slack

. settings.sh

rm /tmp/alp.txt
for host in ${NGINX_HOSTS}
do
    cat alp-nginx.sh | ssh ${SSH_OPTION} ${SSH_USER}@${host} bash >> /tmp/alp.txt 2>&1
    ssh ${SSH_OPTION} ${SSH_USER}@${host} git -C ${REPO_PATH} rev-parse HEAD > /tmp/commit-hash.txt
done

for host in ${APACHE_HOSTS}
do
    cat alp-apache.sh | ssh ${SSH_OPTION} ${SSH_USER}@${host} bash >> /tmp/alp.txt 2>&1
    ssh ${SSH_OPTION} ${SSH_USER}@${host} git -C ${REPO_PATH} rev-parse HEAD > /tmp/commit-hash.txt
done

rm /tmp/pt-query-digest.txt
for host in ${MYSQL_HOSTS}
do
    ssh ${SSH_OPTION} ${SSH_USER}@${host} bash -c "hostname; sudo pt-query-digest /var/log/mysql/mysql-slow.log; echo ''" >> /tmp/pt-query-digest.txt 2>&1
done

BODY=$(cat <<EOS
# score: ${1}

$(cat /tmp/commit-hash.txt)

<details><summary>alp</summary>
<p>

\`\`\`
$(cat /tmp/alp.txt)
\`\`\`

</p>
</details>

<details><summary>pt-query-digest</summary>
<p>

\`\`\`
$(cat /tmp/pt-query-digest.txt)
\`\`\`

</p>
</details>
EOS
)
jq -n --arg body "${BODY}" '{body: $body}' > /tmp/comment.json

url=$(curl -X POST \
    -H "Accept: application/vnd.github.v3+json" \
    -u ${GITHUB_USER}:${GITHUB_TOKEN} \
    -d @/tmp/comment.json \
    https://api.github.com/repos/${GITHUB_ISSUE}/comments \
    | jq -r ".html_url")

echo "finish post-bench" | notify_slack
echo "GitHub Issue コメントはこちら: ${url}" | notify_slack
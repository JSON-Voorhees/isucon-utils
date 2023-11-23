SSH_OPTION=""
SSH_USER="isucon"
ALP_HOST="52.199.200.30"
PT_HOST="52.199.200.30"
DIR="/home/isucon/webapp"

source ./github-setting.sh

ssh ${SSH_OPTION} ${SSH_USER}@${ALP_HOST} "cd ${DIR} && git branch --show-current && git rev-parse HEAD" > /tmp/commit.txt
ssh ${SSH_OPTION} ${SSH_USER}@${ALP_HOST} "cd ${DIR} && make alp" > /tmp/alp.txt
ssh ${SSH_OPTION} ${SSH_USER}@${PT_HOST}  "cd ${DIR} && make pt" > /tmp/pt.txt

BODY=$(cat <<EOS
# score: ${1}

$(cat /tmp/commit.txt)

<details><summary>alp</summary>

\`\`\`

$(cat /tmp/alp.txt)

\`\`\`

</details>

<details><summary>pt-query-digest</summary>

\`\`\`


$(cat /tmp/pt.txt | while read line
do
echo "${line}"
done
)

\`\`\`

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
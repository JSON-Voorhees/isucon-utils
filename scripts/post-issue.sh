SSH_OPTION=""
SSH_USER="isucon"
ALP_HOST="52.195.194.161"
PT_HOST="54.178.4.218"
DIR="/home/isucon/webapp"

GITHUB_USER="youdofoo"
GITHUB_ISSUE="youdofoo/isucon12-final-go/issues/1"  # {owner}/{repo}/issues/{id}

ssh ${SSH_OPTION} ${SSH_USER}@${ALP_HOST} "cd ${DIR} && git rev-parse HEAD" > /tmp/commit.txt
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
echo "${line}" | cut -c -100
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
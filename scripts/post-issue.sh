SSH_OPTION=""
SSH_USER="isucon"
ALP_HOST="35.75.241.171"
PT_HOST="35.79.126.247"
PT_HOST2="52.196.206.96"
DIR="/home/isucon/webapp"

source ./github-setting.sh

# ssh ${SSH_OPTION} ${SSH_USER}@${ALP_HOST} "cd ${DIR} && git branch --show-current && git rev-parse HEAD" > /tmp/commit.txt
# ssh ${SSH_OPTION} ${SSH_USER}@${ALP_HOST} "cd ${DIR} && make alp" > /tmp/alp.txt
# ssh ${SSH_OPTION} ${SSH_USER}@${PT_HOST}  "cd ${DIR} && make pt" > /tmp/pt.txt
# ssh ${SSH_OPTION} ${SSH_USER}@${PT_HOST2}  "cd ${DIR} && make pt" > /tmp/pt2.txt

BODY=$(cat <<EOS
# score: ${1}

$(cat /tmp/commit.txt)

<details><summary>alp</summary>

\`\`\`

$(cat /tmp/alp.txt)

\`\`\`

</details>

<details><summary>pt-query-digest (isupipe)</summary>

\`\`\`


$(cat /tmp/pt.txt | head -n 300 | while read line
do
echo "${line}"
done
)

\`\`\`
</details>

<details><summary>pt-query-digest (isudns)</summary>

\`\`\`


$(cat /tmp/pt2.txt | head -n 300 | while read line
do
echo "${line}" | cut -c 100
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

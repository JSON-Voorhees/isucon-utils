USER="isucon"
SERVERS=""  # 空白区切りでサーバーを指定
DIR=""  # Makefileのあるディレクトリ
B=${1:-main}

for server in ${SERVERS}
do
    ssh ${USER}@${server} "cd ${DIR} && make deploy B=${B}"
done

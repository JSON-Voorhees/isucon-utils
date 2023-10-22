USER="isucon" # ログインユーザー
SERVERS="52.195.194.161 54.178.4.218 54.95.29.197 13.231.134.4 13.115.113.34"  # 空白区切りでサーバーを指定
DIR="/home/isucon/webapp"  # Makefileのあるディレクトリ

B=${1:-main}
for server in ${SERVERS}
do
    ssh ${USER}@${server} "cd ${DIR} && make deploy B=${B}"
done

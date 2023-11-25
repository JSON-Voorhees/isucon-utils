USER="isucon" # ログインユーザー
SERVERS="35.75.241.171 35.79.126.247"
#SERVERS="35.75.241.171 35.79.126.247 52.196.206.96"  # 空白区切りでサーバーを指定
DIR="/home/isucon/webapp"  # Makefileのあるディレクトリ

B=${1:-main}
for server in ${SERVERS}
do
    ssh ${USER}@${server} "cd ${DIR} && make deploy B=${B}"
done

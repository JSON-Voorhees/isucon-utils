USER="isucon" # ログインユーザー
SERVERS="52.199.200.30"  # 空白区切りでサーバーを指定
#SERVERS="52.199.200.30 52.197.7.153 13.115.44.8"  # 空白区切りでサーバーを指定
DIR="/home/isucon/webapp"  # Makefileのあるディレクトリ

B=${1:-main}
for server in ${SERVERS}
do
    ssh ${USER}@${server} "cd ${DIR} && make deploy B=${B}"
done

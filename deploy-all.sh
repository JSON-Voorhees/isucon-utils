SERVERS="isu1 isu2 isu3"  # 空白区切りでサーバーを指定
DIR="/home/isucon/webapp"  # Makefileのあるディレクトリ

B=${1:-main}
for server in ${SERVERS}
do
    ssh ${server} "cd ${DIR} && make deploy B=${B}"
done

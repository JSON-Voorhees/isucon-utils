####################
# 以下はサンプル
# alp の matching、アプリのビルド、設定ファイルのコピー等は状況に合わせて変えること
####################

# alp settings
NGINX_LOG=/var/log/nginx/access.log
MATCHING="/sample/[0-9]+,/sample/index"
FIELDS=count,2xx,3xx,4xx,5xx,method,uri,min,max,sum,avg,p99

# slow query settings
SQ_LOG=/var/log/mysql/mysql-slow.log


TIME=$(shell TZ=JST-9 date +"%H%M")
#### analysis
.PHONY: alp
alp:
	sudo alp ltsv --file ${NGINX_LOG} -m ${MATCHING} -o ${FIELDS} --sort sum --reverse | tee /tmp/alp-$(TIME).txt

.PHONY: alp-slack
alp-slack: alp
	sed -e '1i ```' -e '$$a ```' /tmp/alp-$(TIME).txt | notify_slack

.PHONY: pt
pt:
	sudo pt-query-digest ${SQ_LOG} | tee /tmp/pt-$(TIME).txt

.PHONY: pt-slack
pt-slack: pt
	notify_slack /tmp/pt-$(TIME).txt

.PHONY: pprof
pprof:
	go tool pprof -http=localhost:9999 http://localhost:6060/debug/pprof/profile


#### deploy
REPOSITORY ?= origin
B ?= main
.PHONY: deploy
deploy: git-pull reset-log deploy-app deploy-nginx deploy-mysql

.PHONY: git-pull
git-pull:
	git fetch && \
	git checkout $(B) && \
	git merge $(REPOSITORY)/$(B)

.PHONY: deploy-app
deploy-app:
#	sudo cp ./isuconquest.go.service /etc/systemd/system/ && \
	sudo cp ./env /home/isucon/ && \
	cd /home/isucon/webapp/go/ && \
	/home/isucon/local/golang/bin/go build -o isuconquest && \
	sudo systemctl daemon-reload && \
	sudo systemctl restart isuconquest.go.service

.PHONY: reset-log
reset-log:
	sudo bash -c 'echo "" > /var/log/nginx/access.log'
	sudo bash -c 'echo "" > /var/log/mysql/mysql-slow.log'

.PHONY: deploy-nginx
deploy-nginx:
	sudo cp -rf ./nginx/* /etc/nginx/ && \
	sudo systemctl restart nginx

.PHONY: deploy-mysql
deploy-mysql:
	sudo cp -rf ./mysql/* /etc/mysql/ && \
	sudo systemctl restart mysql
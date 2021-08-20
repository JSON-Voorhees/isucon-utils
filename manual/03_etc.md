# etc以下の設定ファイルのgit管理

## nginx
```sh
sudo cp -rf /etc/nginx ./nginx
sudo chmod -R a+rw ./nginx
sudo mv /etc/nginx{,.bak}
sudo ln -s $(pwd)/nginx /etc/nginx
sudo systemctl restart nginx
```

## apache
```sh
sudo cp -rf /etc/httpd ./httpd
sudo chmod -R a+rw ./httpd
sudo mv /etc/httpd{,.bak}
sudo ln -s $(pwd)/httpd /etc/httpd
sudo systemctl restart httpd
```

## mysql
```sh
sudo cp -rf /etc/mysql ./mysql
sudo chown -R isucon:isucon ./mysql
sudo mv /etc/mysql{,.bak}
sudo ln -s $(pwd)/mysql /etc/mysql
```

mysql を再起動する前に、apparmorの設定を変更する
（apparmorのせいでsymlink先が参照されない可能性があるため）
```sh
sudo vim /etc/apparmor.d/usr.sbin.mysqld
# <パス>/mysql/** r, という行を追加する
```

apparmor と mysql 再起動
```sh
sudo systemctl restart apparmor
sudo systemctl restart mysql
```

## webアプリの systemd unit ファイル
```sh
SERVICE_NAME=<サービス名>
sudo systemctl stop ${SERVICE_NAME}
sudo cp -rf /etc/systemd/system/${SERVICE_NAME} .
sudo mv /etc/systemd/system/${SERVICE_NAME}{,.bak}
sudo ln -s $(pwd)/${SERVICE_NAME} /etc/systemd/system/${SERVICE_NAME}
sudo systemctl daemon-reload
sudo systemctl start ${SERVICE_NAME}
```

## git追加

```sh
git add .
git commit -m "add /etc"
git push
```

以降、追加したいファイルがあったら同じ要領で随時追加
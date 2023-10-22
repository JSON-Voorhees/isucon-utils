# etc以下の設定ファイルのgit管理

## nginx
```sh
sudo cp -rf /etc/nginx ./nginx
sudo chmod -R a+rw ./nginx
sudo mv /etc/nginx{,.bak}
```

## apache
```sh
sudo cp -rf /etc/httpd ./httpd
sudo chmod -R a+rw ./httpd
sudo mv /etc/httpd{,.bak}
```

## mysql
```sh
sudo cp -rf /etc/mysql ./mysql
sudo chown -R isucon:isucon ./mysql
sudo mv /etc/mysql{,.bak}
```

## webアプリの systemd unit ファイル
```sh
SERVICE_NAME=<サービス名>
sudo systemctl stop ${SERVICE_NAME}
sudo cp -rf /etc/systemd/system/${SERVICE_NAME} .
sudo mv /etc/systemd/system/${SERVICE_NAME}{,.bak}
```

## git追加

```sh
git add .
git commit -m "add /etc"
git push
```

以降、追加したいファイルがあったら同じ要領で随時追加
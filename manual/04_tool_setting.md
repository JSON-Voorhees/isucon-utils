# 解析ツール設定

## alp
ログの形式をltsvにするよう設定ファイルを編集

もとのログ設定はコメントアウトする

その後、サービスを再起動

### nginx

```nginx
log_format ltsv "time:$time_local"
                "\thost:$remote_addr"
                "\tforwardedfor:$http_x_forwarded_for"
                "\treq:$request"
                "\tstatus:$status"
                "\tmethod:$request_method"
                "\turi:$request_uri"
                "\tsize:$body_bytes_sent"
                "\treferer:$http_referer"
                "\tua:$http_user_agent"
                "\treqtime:$request_time"
                "\tcache:$upstream_http_x_cache"
                "\truntime:$upstream_http_x_runtime"
                "\tapptime:$upstream_response_time"
                "\tvhost:$host";

access_log  /var/log/nginx/access.log  ltsv;
```

### apache

```apache
LogFormat "time:%t\tforwardedfor:%{X-Forwarded-For}i\thost:%h\treq:%r\tstatus:%>s\tmethod:%m\turi:%U%q\tsize:%B\treferer:%{Referer}i\tua:%{User-Agent}i\treqtime_microsec:%D\tapptime:%D\tcache:%{X-Cache}o\truntime:%{X-Runtime}o\tvhost:%{Host}i" ltsv

CustomLog /var/log/httpd/access_log ltsv
```

### H2O
（わからん）
```
access-log:
  path: /var/log/h2o/access.log
  format: "time:%t\thost:%h\tua:\"%{User-agent}i\"\tstatus:%s\treq:%r\turi:%U\tapptime:%{duration}x\tsize:%b\tmethod:%m"
```

## pt-query-digest (スロークエリ)

### スロークエリ設定
my.cnf に以下を記載
```
slow_query_log         = 1
slow_query_log_file    = /var/log/mysql/mysql-slow.log
long_query_time = 0
```

mysql再起動
```sh
sudo systemctl restart mysql
```

変更が反映されていることを確認
```sh
echo 'show variables like "slow_query%";' | mysql -u isucari -pisucari
echo 'show variables like "long_query_time";' | mysql -u isucari -pisucari
```

## スクリプトの設定

`scripts/settings.sh` にホスト名やSSHのオプションなどを設定する

`scripts/alp-nginx.sh` または `scripts/alp-apache.sh` の `ALP_OPTIONS` にURIの変数をまとめる以下のような設定を入れる（以下はisucon10の例）

どのようにまとめるかはソースコードを見ればわかるはず

```
-m /api/estate/[0-9]+,/api/chair/[0-9]+,/api/estate/req_doc/[0-9]+
```

## alpの結果をブラウザから見られるようにする設定
`/www/data/logs/alp.html` に出すようにしているので、そこへのルーティングを追加すれば良い

```nginx
http {
    ...
    server{
        ...
        location /logs/ {
            root /www/data;
            index alp.html;
        }
        ...
    }
    ...
}
```
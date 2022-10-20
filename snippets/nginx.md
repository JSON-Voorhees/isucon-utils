# nginx

## ロードバランシング

```
http {
    upstream backend {
        server backend1.example.com;
        server backend2.example.com;
        server 192.0.0.1 backup;
    }
    
    server {
        location / {
            proxy_pass http://backend;
        }
    }
}
```

## ブラウザ側でのキャッシュ

`expires` ディレクティブで max-age も設定できる。

`add_header` ディレクティブで Cache-Control ヘッダに追加。

```
http {
    server {
        location / {
            expires 30d;
            add_header Cache-Control public;
        }
    }
}
```

## nginxでのキャッシュ

```
http {
    # ...
    proxy_cache_path /data/nginx/cache keys_zone=one:10m;
    server {
        proxy_cache one;
        location / {
            proxy_pass http://localhost:8000;
        }
    }
}
```

## ヘッダ確認用のログフォーマット
```
log_format header
  '[$time_local]\n'
  '$request\n'
  'request ------------\n'
  'remote_addr: $remote_addr\n'
  'remote_user: $remote_user\n'
  'request_time: $request_time\n'
  'host: $http_host\n'
  'referer: $http_referer\n'
  'accept_encoding: $http_accept_encoding\n'
  'accept_language: $http_accept_language\n'
  'user_agent: $http_user_agent\n'
  'x_forwarded_proto: $http_x_forwarded_proto\n'
  'x_forwarded_for: $http_x_forwarded_for\n'
  'x_forwarded_host: $http_x_forwarded_host\n'
  'x_real_ip: $http_x_real_ip\n'
  'response ------------\n'
  'status: $status\n'
  'size: $body_bytes_sent\n'
  'content_type: $sent_http_content_type\n';        
```
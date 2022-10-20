# mysql

## 外部からアクセスできるようにする
mysqld.cnf とかにある `bind_address` をコメントアウト
```
# bind-address = 127.0.0.1
```

登録されているユーザーとホストを確認
```sql
SELECT user, host FROM mysql.user
```

もし、isuconユーザーがホスト`%`で登録されていなかったら
```sql
GRANT ALL PRIVILEGES ON *.* TO "isucon"@"%";
```
で権限付与

## クエリキャッシュ

調べたら非推奨らしい。

設定の確認
```sql
SHOW VARIABLES LIKE '%query_cache_%';
```
`query_cache_type` が ON になっていれば有効になっている。

OFFになっていたら mysqld.cnf とかに
```
query_cache_type = 1
```
を設定する

キャッシュのヒット率なんかは以下のクエリで確認
```
show session status like 'Qcache%';
```

参考:
https://qiita.com/mamy1326/items/d1548d8cf4528277172a

## 同時接続数とスレッド

```sql
SELECT * FROM GLOBAL_STATUS WHERE VARIABLE_NAME = 'Connections' OR VARIABLE_NAME LIKE 'Threads%';
```
でこれまでの接続数と、現在の接続数、スレッドを作成した回数が確認できる。

THREADS_CONNECTED が max_connections に達しているようだったら max_connections を上げる（デフォルトは151）

THREADS_CREATED が多い場合は、スレッドの生成・破棄のオーバーヘッドを減らすために、 thread_cache_size を上げる（デフォルトは9）

## バッファプールサイズ

```sql
SHOW GLOBAL VARIABLES LIKE 'innodb_buffer_pool_%';
```
で確認できる。

`innodb_buffer_pool_size` でサイズ設定。

大体余ったメモリの8割を割り当てると良いらしい。

数GBぐらいある場合は、 `innodb_buffer_pool_instances` を調整して、1インスタンスあたり1GB以上になるようにする。
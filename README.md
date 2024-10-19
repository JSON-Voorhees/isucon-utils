# ISUCON チートシート

## 最初にやること手順
1. 手順に従ってインスタンスを立てる
2. 立ち上がったらグローバルIPアドレスを確認し、ローカルの `~/.ssh/config` に反映する
    ```
    Host isu1
        HostName xx.xx.xx.xx 
        LocalForward 9000 localhost:9000 # pprotein用
        LocalForward 3000 localhost:3000 # Grafana用

    Host isu2
        HostName xx.xx.xx.xx

    Host isu3
        HostName xx.xx.xx.xx

    Host isu*
        User isucon
        Port 22
        ServerAliveInterval 60
        ServerAliveCountMax 5
        StrictHostKeyChecking no
    ```
3. ansible を実行する
    ```bash
    $ cd ./ansible
    $ make run
    ```
4. ssh 設定時に出力された台数分の公開鍵を GitHub のデプロイキーに登録する
5. isu1 へログインし、webapp を git 管理にする
    ```bash
    $ ssh isu1
    $ cd webapp/    # 問題によって違う可能性あり
    $ git init

    # 以下のコマンドを実行し、画像等サイズの大きなファイルは .gitignore へ入れる
    $ du --max-depth 1 -h

    $ git add .
    $ git branch -M main
    $ git remote add origin ＜リポジトリ＞
    $ git push -u origin main
    ```
6. isu2, isu3 へログインし、webapp を git 管理にする
    ```bash
    $ ssh isu2
    $ cd webapp/    # 問題によって違う可能性あり
    $ git init
    $ git branch -M main
    $ git remote add origin ＜リポジトリ＞
    $ git fetch origin main
    $ git reset --hard FETCH_HEAD

    # isu3 でも同様の手順を実行
    ```
7. ローカルで git pull
8. Makefile の「問題ごとに変わる設定」に値を入力して、commit & push
    * `SERVICE_NAME` は `systemctl list-unit-files | grep -e go -e isu` あたりで確認
9. isu1 上でデプロイ実行
    ```bash
    $ make deploy
    ```
10. isu1 上で `make set-alp-group` を実行し、pprotein の alp 設定に API のパターンを登録する
11. pprotein で pprof を有効化する
    ```bash
    $ cd go
    $ go get github.com/kaz/pprotein/integration/standalone
    $ go mod tidy
    ```

    ```go
    func main() {
        // 中略
        go standalone.Integrate(":19001")
    }
    ```
12. /initialize の処理の最後に pprotein の計測を開始するコードを入れる
    ```go
    go func() {
		if _, err := http.Get("http://127.0.0.1:9000/api/group/collect"); err != nil {
			log.Printf("failed to communicate with pprotein: %v", err)
		}
	}()
    ```
13. ベンチマークを実行する
14. pprotein の結果を確認する
    * http://localhost:9000/#/group/

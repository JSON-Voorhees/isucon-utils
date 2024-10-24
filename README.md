# ISUCON チートシート

## 事前にやること
* `./create-gh-repo.sh` で GitHub リポジトリを作成しておく（デプロイキーの登録も行われる）
    ```bash
    $ ./create-gh-repo.sh JSON-Voorhees/repo_name
    ```
* `ansible/hosts` の `github_repo` に作成したリポジトリ名を設定する

## 最初にやること手順
1. 手順に従ってインスタンスを立てる
1. 立ち上がったらグローバルIPアドレスを確認し、ローカルの `~/.ssh/config` に反映する
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
1. isu1 へログインし、ディレクトリ構成や起動しているサービス、システム情報を確認する。確認の結果 `ansible/hosts` や `roles/` の修正が必要であれば行う
    ```bash
    $ ssh isu1
    # ディレクトリ構成の確認
    $ ls ~
    $ ls ~/webapp
    # 起動しているサービスの確認
    $ systemctl list-unit-files | grep -e nginx -e mysql -e isu -e go
    # システム情報の確認
    $ uname -a
    ```
1. ansible を実行する
    ```bash
    $ cd ./ansible
    $ make run
    ```
1. ssh 設定時に出力された台数分の公開鍵を GitHub のデプロイキーに登録する
1. isu1 へログインし、webapp を git 管理にする
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
1. isu2, isu3 へログインし、webapp を git 管理にする
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
1. ローカルで git pull
1. Makefile の「問題ごとに変わる設定」に値を入力して、commit & push
    * `SERVICE_NAME` は `systemctl list-unit-files | grep -e go -e isu` あたりで確認
1. isu1 上でデプロイ実行
    ```bash
    $ make deploy
    ```
1. isu1 上で `make set-alp-group` を実行し、pprotein の alp 設定に API のパターンを登録する
1. pprotein で pprof を有効化する
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
1. /initialize の処理の最後に pprotein の計測を開始するコードを入れる
    ```go
    go func() {
		if _, err := http.Get("http://127.0.0.1:9000/api/group/collect"); err != nil {
			log.Printf("failed to communicate with pprotein: %v", err)
		}
	}()
    ```
1. ベンチマークを実行する
1. pprotein の結果を確認する
    * http://localhost:9000/#/group/

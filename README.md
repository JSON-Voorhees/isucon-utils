# ISUCON チートシート

## 事前にやること
* `./create-gh-repo.sh` で GitHub リポジトリを作成しておく（デプロイキーの登録も行われる）
    ```bash
    # ローカルで実行
    ./create-gh-repo.sh JSON-Voorhees/repo_name
    ```
* `ansible/hosts` の `github_repo` に作成したリポジトリ名を設定する
* ローカルに作成したリポジトリを clone しておく

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
1. isu1 へログインし、ディレクトリ構成や起動しているサービス、システム情報を確認する。確認の結果に応じて hosts や Makefile 等の修正を行う
    * チェックリスト
      * アプリのディレクトリは `/home/isucon/webapp` か
        ```bash
        # isu1 で実行
        ls ~/webapp
        ```
      * web サーバーは nginx か
        ```bash
        # isu1 で実行
        systemctl status nginx
        ```
      * RDBMS は mysql か
        ```bash
        # isu1 で実行
        systemctl status mysql
        ```
      * CPU アーキテクチャは x86_64 か
        ```bash
        # isu1 で実行
        uname -a
        ```
      * アプリサービスの確認
        ```bash
        # isu1 で実行
        systemctl list-unit-files | grep -e isu
        ```
      * アプリビルド方法の確認
        ```bash
        # isu1 で実行
        ls ~/webapp/go
        cat ~/webapp/Makefile
        ```
      * アプリ環境変数ファイルの確認
        ```bash
        # isu1 で実行
        ls ~/env.sh
        ```
1. ansible を実行する
    ```bash
    # ローカル(isucon-utils)で実行
    cd ./ansible
    make run
    ```
1. webapp を git 管理にする
    ```bash
    # isu1 で実行
    cd webapp/    # 問題によって違う可能性あり

    # 以下のコマンドを実行し、画像等サイズの大きなファイルは .gitignore へ入れる
    du -d 1 -h

    # git init 等は ansible で実行済み
    git add .
    git commit -m "initial"
    git push -u origin main
    ```
1. isu2, isu3 へログインし、webapp を git 管理にする
    ```bash
    # isu2, isu3 で実行
    cd webapp/    # 問題によって違う可能性あり
    
    git fetch origin main
    git reset --hard FETCH_HEAD
    ```
1. ローカルで git pull
1. デプロイ実行
    ```bash
    # ローカル(isucon-utils)で実行
    make deploy B=main
    ```
1. pprotein の alp 設定に API のパターンを登録する
    ```bash
    # isu1 で実行
    make set-alp-group
    ```
1. pprotein で pprof を有効化する
    ```bash
    # ローカル(webapp)で実行
    cd go/
    go get github.com/kaz/pprotein/integration/standalone
    go mod tidy
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
1. git commit & push し、デプロイ
    ```bash
    # ローカル(isucon-utils)で実行
    make deploy B=main
    ```
1. ベンチマークを実行する
1. pprotein の結果を確認する
    * http://localhost:9000/#/group/

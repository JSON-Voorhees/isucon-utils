# デプロイ・計測結果集計スクリプト

## 事前準備
`Makefile` を対象サーバーに配布し、サーバー単体のデプロイと集計が行えるようにしておく

## デプロイ

### 設定

`deploy-all.sh` の冒頭部分の下記変数に設定を記載する。
```sh
USER="isucon"                     # ログインユーザー
SERVERS="xx.xx.xx.xx yy.yy.yy.y"  # 空白区切りでサーバーを指定
DIR="/home/isucon/webapp"         # Makefile のあるディレクトリ
```

### デプロイ実行

```sh
$ bash ./deploy-all.sh [ブランチ名]
# ブランチ名を省略すると main ブランチがデプロイされる
```

## 計測結果を集計し GitHub の issue に投稿

### 設定

#### GitHub の設定
`github-setting.sh.example` をコピーして `github-setting.sh` というファイルを作る
```sh
$ cp github-setting.sh{.example,}
```

`github-setting.sh` の下記変数に値を設定する
```sh
export GITHUB_USER="username"                     # GitHub のユーザー名
export GITHUB_TOKEN="personal_access_token"       # Personal Access Token
export GITHUB_ISSUE="{owner}/{repo}/issues/{id}"  # 投稿先の issue 
```

#### サーバー設定
`post-issue.sh` の冒頭部分に下記変数に設定を記載する。
```sh
SSH_USER="isucon"           # SSH ユーザー
SSH_OPTION=""               # SSH 時のオプション
ALP_HOST="52.195.194.161"   # ALB で集計を実行するホスト
PT_HOST="54.178.4.218"      # pt-query-digest で集計を実行するホスト
DIR="/home/isucon/webapp"   # Makefile のあるディレクトリ
```

### 集計・投稿実行

```sh
$ bash ./post-issue.sh
```
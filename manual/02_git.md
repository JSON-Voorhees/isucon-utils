# git 設定

## デプロイキー登録

```sh
cat ~/.ssh/id_rsa.pub
```

github リポジトリのデプロイキーに公開鍵を登録

https://github.com/JSON-Voorhees/isucon9q/settings/keys

## github へ push

アプリのディレクトリに移動

git 管理にして、githubへpush

このとき画像ファイルなどサイズが大きくてgithubに上げられないものは .gitignore に追加する

```sh
git init
git add .
git branch -M main
git remote add origin git@github.com:JSON-Voorhees/isucon9q.git
git push -u origin main
```
# git 設定

## github へ push

アプリのディレクトリに移動

git 管理にして、githubへpush

このとき画像ファイルなどサイズが大きくてgithubに上げられないものは .gitignore に追加する

```sh
git init
git add .
git branch -M main
git remote add origin ＜リポジトリ＞
git push -u origin main
```
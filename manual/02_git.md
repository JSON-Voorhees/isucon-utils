# git 設定

## git 初期設定とデプロイキー登録

メールアドレスとユーザー名を登録（適当で良い）
```sh
git config --global user.email "isucon@example.com"
git config --global user.name "isucon"
```

鍵生成（パスフレーズはなし）
```sh
ssh-keygen -t rsa -b 4096

cat ~/.ssh/id_rsa.pub
```

github リポジトリのデプロイキーに公開鍵を登録

https://github.com/JSON-Voorhees/isucon9q/settings/keys

## github へ push

アプリのディレクトリに移動

git 管理にして、githubへpush
```sh
git init
git add .
git branch -M main
git remote add origin git@github.com:JSON-Voorhees/isucon9q.git
git push -u origin main
```
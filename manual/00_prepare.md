# 事前にやっておくこと
## GitHub の設定
* GitHub リポジトリの作成
* GitHub リポジトリへのデプロイキーの登録
  * [ansible/roles/ssh/files/](../ansible/roles/ssh/files) にキーがある
  * ない場合は事前に発行しておく
* 計測結果用の issue 作成
* [scripts/](../scripts/) の記載にしたがって GitHub の設定をする
  * Personal Access Token の発行

## SSH の設定
* [ansible/hosts](../ansible/hosts) の `ansible_user` と `ansible_ssh_private_key_file` をログインに使用するものに変更しておく


# ansible を実行する
`ansible/hosts` の `[webservers]` にホストを追加

また、`notify_slack_url`, `notify_slack_token`, `notify_slack_channel` にも値を設定しておく

```
[webservers]
<ホスト>

[webservers:vars]
ansible_port=22
ansible_user=isucon
ansible_ssh_private_key_file=~/.ssh/id_rsa

notify_slack_url=""
notify_slack_token=""
notify_slack_channel=""

```

ansible 実行
```sh
ansible-playbook -i hosts site.yml
```

これにより、

* 解析ツールのインストール
* SSH設定
* gitの基本設定

が完了する

一度ログアウトして、isuconユーザーで直接ログインできることを確認
```sh
ssh isucon@<ホスト>
```
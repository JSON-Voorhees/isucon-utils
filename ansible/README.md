# ansible play book

## 実行方法
### 1. ホスト設定
`hosts.example` を `hosts` に変更し、値を変更する
```ini
[webservers]
XX.XX.XX.XX     # ホストのIPアドレス

[webservers:vars]
ansible_port=22         # SSH の接続先ポート
ansible_user=isucon     # SSH のユーザー名
ansible_ssh_private_key_file=~/.ssh/id_rsa  # SSH の秘密鍵

# notify_slack の設定
notify_slack_url="https://hooks.slack.com/..."  # Slack の webhook URL
```

### 2. ansible 実行
```bash
$ ansible-playbook -i hosts site.yml
```
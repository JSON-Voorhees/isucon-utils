isuconユーザーのログインシェルをbashにする
```
sudo chsh -s /bin/bash isucon
```

動いているサービス確認
```
systemctl list-units --type=service --state=running
```

netdataのアンインストール
```
sudo /usr/libexec/netdata/netdata-uninstaller.sh --yes
```
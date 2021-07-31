#!/bin/bash

ALP_OPTIONS="-r --sort=avg -m /api/estate/[0-9]+,/api/chair/[0-9]+,/api/estate/req_doc/[0-9]+,/api/recommended_estate/[0-9]+,/api/chair/buy/[0-9]+"

sudo mkdir -p /www/data/logs
sudo echo "<html><body><pre style=\"font-family: 'Courier New', Consolas\">" | sudo tee /www/data/logs/alp.html > /dev/null

hostname
sudo cat /var/log/nginx/access.log | alp ltsv ${ALP_OPTIONS} | sudo tee -a /www/data/logs/alp.html
echo ""
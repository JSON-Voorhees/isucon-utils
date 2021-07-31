#!/bin/bash

ALP_OPTIONS="-r --sort=avg -m /api/estate/[0-9]+,/api/chair/[0-9]+,/api/estate/req_doc/[0-9]+,/api/recommended_estate/[0-9]+,/api/chair/buy/[0-9]+"

sudo mkdir -p /var/www/html/logs
sudo echo "<html><body><pre style=\"font-family: 'Courier New', Consolas\">" | sudo tee /var/www/html/logs/alp.html > /dev/null

hostname
sudo cat /var/log/httpd/access_log | alp ltsv ${ALP_OPTIONS} | sudo tee -a /var/www/html/logs/alp.html
echo ""
#!/bin/bash

ALP_OPTIONS="-r --sort=avg"

sudo mkdir -p /var/www/html/logs
sudo echo "<html><body><pre style=\"font-family: 'Courier New', Consolas\">" | sudo tee /var/www/html/logs/alp.html > /dev/null

hostname
sudo cat /var/log/httpd/access_log | alp ltsv ${ALP_OPTIONS} | sudo tee -a /var/www/html/logs/alp.html
echo ""
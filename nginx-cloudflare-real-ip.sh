#!/bin/bash
# Simple bash script to restore visitor real IP under Cloudflare with Nginx
# Script also whitelist cloudflare IP with UFW (if installed)

if [ ! -x /usr/bin/curl ]; then
echo "####################################"
echo "Installing CURL"
echo "####################################"
sudo apt-get update
sudo apt-get install curl -y
fi

IPV4=$(curl -s https://www.cloudflare.com/ips-v4)
IPV6=$(curl -s https://www.cloudflare.com/ips-v6)

echo '' >/etc/nginx/conf.d/cloudflare.conf
echo "####################################"
echo "Adding Cloudflare IPv4"
echo "####################################"
for cf_ip in $IPV4; do
    echo "set_real_ip_from $cf_ip;" >>/etc/nginx/conf.d/cloudflare.conf
    if [ -x /usr/sbin/ufw ]; then
        sudo ufw allow from $cf_ip to any port 80
        sudo ufw allow from $cf_ip to any port 443
    fi
done
echo "####################################"
echo "Adding Cloudflare IPv6"
echo "####################################"
for cf_ip in $IPV6; do
    echo "set_real_ip_from $cf_ip;" >>/etc/nginx/conf.d/cloudflare.conf
    if [ -x /usr/sbin/ufw ]; then
        sudo ufw allow from $cf_ip to any port 80
        sudo ufw allow from $cf_ip to any port 443
    fi
done
echo 'real_ip_header CF-Connecting-IP;' >>/etc/nginx/conf.d/cloudflare.conf

VERIFY_NGINX_CONFIG=$(nginx -t 2>&1 | grep failed)
echo "####################################"
echo "Checking Nginx configuration"
echo "####################################"
if [ -z "$VERIFY_NGINX_CONFIG" ]; then
echo "####################################"
echo "Reloading Nginx"
echo "####################################"
sudo service nginx reload
else
echo "####################################"
echo "Nginx configuration is not correct"
echo "####################################"
fi

if [ -x /usr/sbin/ufw ]; then
echo "####################################"
echo "Reloading UFW"
echo "####################################"
   sudo ufw reload
fi

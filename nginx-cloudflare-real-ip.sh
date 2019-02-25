#!/bin/bash
# Simple bash script to restore visitor real IP under Cloudflare with Nginx
# Script also whitelist cloudflare IP with UFW (if installed)

if [ "$1" = "--ufw" ]; then
 CF_UFW_SETUP="y"
fi

if [ -z "$(command -v curl)" ]; then
echo "####################################"
echo "Installing CURL"
echo "####################################"
sudo apt-get update
sudo apt-get install curl -y
fi

CF_IPV4=$(curl -sL https://www.cloudflare.com/ips-v4)
CF_IPV6=$(curl -sL https://www.cloudflare.com/ips-v6)

[ ! -d /etc/nginx/conf.d ] && {
    sudo mkdir -p /etc/nginx/conf.d
}

echo '' >/etc/nginx/conf.d/cloudflare.conf
echo "####################################"
echo "Adding Cloudflare IPv4"
echo "####################################"
for cf_ip4 in $CF_IPV4; do
    echo "set_real_ip_from $cf_ip4;" >>/etc/nginx/conf.d/cloudflare.conf
    if [ "$CF_UFW_SETUP" = "y" ]; then
        sudo ufw allow from $cf_ip4 to any port 80
        sudo ufw allow from $cf_ip4 to any port 443
    fi
done
echo "####################################"
echo "Adding Cloudflare IPv6"
echo "####################################"
for cf_ip6 in $CF_IPV6; do
    echo "set_real_ip_from $cf_ip;" >>/etc/nginx/conf.d/cloudflare.conf
    if [ "$CF_UFW_SETUP" = "y" ]; then
        sudo ufw allow from $cf_ip6 to any port 80
        sudo ufw allow from $cf_ip6 to any port 443
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

if [ "$CF_UFW_SETUP" = "y" ]; then
echo "####################################"
echo "Reloading UFW"
echo "####################################"
   sudo ufw reload
fi

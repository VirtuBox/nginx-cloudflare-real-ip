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
    apt-get update
    apt-get install curl -y
fi

CURL_BIN=$(command -v curl)
CF_IPV4=$($CURL_BIN -sL https://www.cloudflare.com/ips-v4)
CF_IPV6=$($CURL_BIN -sL https://www.cloudflare.com/ips-v6)

[ ! -d /etc/nginx/conf.d ] && {
    mkdir -p /etc/nginx/conf.d
}

echo '' > /etc/nginx/conf.d/cloudflare.conf
echo "####################################"
echo "Adding Cloudflare IPv4"
echo "####################################"
for cf_ip4 in $CF_IPV4; do
    echo "set_real_ip_from $cf_ip4;" >> /etc/nginx/conf.d/cloudflare.conf
    if [ "$CF_UFW_SETUP" = "y" ]; then
        ufw allow from $cf_ip4 to any port 80
        ufw allow from $cf_ip4 to any port 443
    fi
done
echo "####################################"
echo "Adding Cloudflare IPv6"
echo "####################################"
for cf_ip6 in $CF_IPV6; do
    echo "set_real_ip_from $cf_ip6;" >> /etc/nginx/conf.d/cloudflare.conf
    if [ "$CF_UFW_SETUP" = "y" ]; then
        ufw allow from $cf_ip6 to any port 80
        ufw allow from $cf_ip6 to any port 443
    fi
done
echo 'real_ip_header CF-Connecting-IP;' >> /etc/nginx/conf.d/cloudflare.conf

if [ "$CF_UFW_SETUP" = "y" ]; then
    echo "####################################"
    echo "Reloading UFW"
    echo "####################################"
    ufw reload
fi

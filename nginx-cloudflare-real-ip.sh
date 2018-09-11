#!/bin/bash
# Simple bash script to restore visitor real IP under Cloudflare with Nginx
# Script also whitelist cloudflare IP with UFW (if installed)

IPV4=$(curl -q https://www.cloudflare.com/ips-v4)
IPV6=$(curl -q https://www.cloudflare.com/ips-v6)

echo '' >/etc/nginx/conf.d/cloudflare.conf
for cfip in $IPV4; do
    echo "set_real_ip_from $cfip;" >>/etc/nginx/conf.d/cloudflare.conf
    if [ -x /usr/sbin/ufw ]; then
        ufw allow from $cfip to any port 80
        ufw allow from $cfip to any port 443
    fi
done
for cfip in $IPV6; do
    echo "set_real_ip_from $cfip;" >>/etc/nginx/conf.d/cloudflare.conf
    if [ -x /usr/sbin/ufw ]; then
        ufw allow from $cfip to any port 80
        ufw allow from $cfip to any port 443
    fi
done

echo 'real_ip_header CF-Connecting-IP;' >>/etc/nginx/conf.d/cloudflare.conf

if [ -x /usr/sbin/ufw ]; then
    ufw reload
fi

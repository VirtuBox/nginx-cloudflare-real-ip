# nginx-cloudflare-real-ip

Configure Nginx to restore Visitor real IP under Cloudflare CDN

## Features

* Get Cloudflare IPv4 + IPv6 list and create nginx configuration to restore visitors real IP in `/etc/nginx/conf.d/cloudflare.conf`
* If UFW is installed, whitelist Cloudflare IPs on port 80 & 443

## Requirements

* Nginx built with http_realip_module

You can check if http_realip_module available with :

```bash
nginx -V 2>&1 | grep with-http_realip_module
```

If the previous command return nothing, http_realip_module isn't available

---

## Usage

```bash
bash <(wget -O - https://raw.githubusercontent.com/VirtuBox/nginx-cloudflare-real-ip/master/nginx-cloudflare-real-ip.sh)
```


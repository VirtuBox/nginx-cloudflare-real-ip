# nginx-cloudflare-real-ip

Configure Nginx to restore Visitors real IP under Cloudflare CDN

## Features

* Get Cloudflare IPv4 + IPv6 list and create nginx configuration to restore visitors real IP in `/etc/nginx/conf.d/cloudflare.conf`
* Whitelist Cloudflare IPs on port 80 & 443 with UFW (optional)

## Requirements

* Nginx built with http_realip_module

You can check if http_realip_module available with :

```bash
nginx -V 2>&1 | grep with-http_realip_module
```

If the previous command return nothing, http_realip_module isn't available

---

## Usage

Nginx configuration only

```bash
bash <(wget -O - vtb.cx/nginx-cloudflare || curl -sL vtb.cx/nginx-cloudflare)
```

Nginx configuration + UFW configuration

```bash
bash <(wget -O - vtb.cx/nginx-cloudflare || curl -sL vtb.cx/nginx-cloudflare) --ufw
```

Published & maintained by [VirtuBox](https://virtubox.net)
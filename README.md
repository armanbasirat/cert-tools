The script is self-explanatory!
lego(let's encrypt go) project is used to automate wildcard certificate generation using arvan api!

With a simple cron job you can renew certificates!

for generate new cert <your-domain> just clone and run below cmd:
```
 ./ssl-renew.sh 90 <your-domain> <your-domain> <your-email> ./ cloudflare(or arvancloud) CF_API_TOKEN(or ARVANCLOUD_API_KEY='Apikey {UUID}')
```
and for checking the cert expiration run below cmd:
```
./ssl-expiry.sh <your-domain>
```
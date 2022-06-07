#!/bin/bash
BASE_PATH=`dirname "$(readlink -f "$0")"`
WEBSITE=$2
DAYS_TILL_EXPIRATION=$($BASE_PATH/ssl-expiry.sh $WEBSITE)
DAYS_TILL_EXPIRATION=${DAYS_TILL_EXPIRATION:-0}
THRESHOLD=$1
MAIL=$4
CERT_DIR=`readlink -f $5`
PROVIDER=$6
IFS=','
doamains=$3
for domain in ${doamains[@]}
do
    DOMAINS=$DOMAINS`echo "--domains $domain "`
done
echo $DOMAINS

if [ $DAYS_TILL_EXPIRATION -lt $THRESHOLD ]; then
    if [ $PROVIDER = 'arvancloud' ]; then
        /usr/bin/env docker run -v $CERT_DIR:/certs -e MAIL=$4 -e DOMAIN=$DOMAINS -e ARVANCLOUD_API_KEY=$7 --entrypoint /bin/sh goacme/lego -c 'echo $ARVANCLOUD_API_KEY && lego -k rsa2048 $DOMAIN -m $MAIL --dns arvancloud -a --dns-timeout 60 --dns.resolvers 1.1.1.1:53 --path /certs run'
    elif [ $PROVIDER = 'cloudflare' ]; then
        /usr/bin/env docker run -v $CERT_DIR:/certs -e MAIL=$4 -e DOMAIN=$DOMAINS -e CF_DNS_API_TOKEN=$7 --entrypoint /bin/sh goacme/lego -c 'echo $CF_DNS_API_TOKEN && lego -k rsa2048 $DOMAIN -m $MAIL --dns cloudflare -a --dns-timeout 60 --dns.resolvers 1.1.1.1:53 --path /certs run'
    else
        echo 'not valid provider'
    fi
fi

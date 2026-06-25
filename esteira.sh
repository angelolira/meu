#!/bin/bash

DNS1="172.16.8.29"
DNS2="172.16.8.30"

CONN=$(nmcli -t -f NAME connection show --active | head -1)

if [ -z "$CONN" ]; then
    echo "Nenhuma conexão ativa."
    exit 1
fi

echo "Conexão: $CONN"

nmcli connection modify "$CONN" ipv4.ignore-auto-dns yes
nmcli connection modify "$CONN" ipv4.dns "$DNS1,$DNS2"

nmcli connection down "$CONN"
nmcli connection up "$CONN"

echo
echo "DNS configurados:"
nmcli device show | grep DNS

echo
cat /etc/resolv.conf

ping -c 1 google.com
ping -c 1 intranet.unicesumar.edu.br
ping -c 1 portaluniasselvi.com.br

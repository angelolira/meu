#!/bin/bash

DNS1="172.16.10.150"
DNS2="172.16.10.151"

# Obtém a conexão ativa
CONN=$(nmcli -t -f NAME,DEVICE connection show --active | grep -v ':$' | head -1 | cut -d: -f1)

if [ -z "$CONN" ]; then
    echo "Nenhuma conexão ativa encontrada."
    exit 1
fi

echo "Conexão encontrada: $CONN"

# Configura os DNS
nmcli connection modify "$CONN" ipv4.dns "$DNS1 $DNS2"
nmcli connection modify "$CONN" ipv4.ignore-auto-dns yes

# Reaplica a configuração sem derrubar a conexão
nmcli device reapply "$(nmcli -t -f DEVICE connection show --active | head -1)"

# Reinicia a conexão caso o reapply não funcione
nmcli connection up "$CONN"

echo
echo "Novo resolv.conf:"
cat /etc/resolv.conf

echo
echo "Configuração aplicada:"
nmcli connection show "$CONN" | grep ipv4.dns

#!/bin/bash

# Install dependencies
apt update
apt install nut

# Ask for the server's hostname

read -p "Enter the server hostname: " SERVER_HOSTNAME

# Ask for the client's hostname

DEFAULT_CLIENT_HOSTNAME=$(cat /etc/hostname)
read -p "Enter the client hostname (leave empty to use '$DEFAULT_CLIENT_HOSTNAME'): " CLIENT_HOSTNAME
if [ -z "$CLIENT_HOSTNAME" ]; then
    CLIENT_HOSTNAME="$DEFAULT_CLIENT_HOSTNAME"
fi

# Config generation: PSK

CONFIG_DIR="/etc/zabbix/zabbix_agentd.d"
PSK_FILE="$CONFIG_DIR/psk"
openssl rand -hex 64 > "$PSK_FILE"

# Set ownership and permissions
chown zabbix:zabbix "$PSK_FILE"
chmod 0600 "$PSK_FILE"

# Config generation

TEMPLATE_FILE="$CONFIG_DIR/client-active-template.conf"
OUTPUT_FILE="$CONFIG_DIR/client-active.conf"

if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "Template file $TEMPLATE_FILE does not exist!"
    exit 1
fi

sed -e "s/\[SERVER_HOSTNAME\]/$SERVER_HOSTNAME/g" \
    -e "s/\[CLIENT_HOSTNAME\]/$CLIENT_HOSTNAME/g" \
    "$TEMPLATE_FILE" > "$OUTPUT_FILE"

# END

PSK_CONTENT=$(cat "$PSK_FILE")
echo "Success! The configuration has been saved."
echo ""
echo "Client hostname: $CLIENT_HOSTNAME"
echo "Generated PSK  : $PSK_CONTENT"
echo ""
echo "You can now restart the Zabbix agent using the following command:"
echo "service zabbix-agent restart"
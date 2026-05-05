#!/bin/bash

git submodule init && git submodule update

# Install dependencies
apt update
apt install nut

CONFIG_DIR="$(dirname "$0")/zabbix_agent2.d"

# ZFS_ON_LINUX
wget -q https://raw.githubusercontent.com/zabbix/community-templates/refs/heads/main/Operating_Systems/Linux/template_zfs_on_linux_active/7.0/files/userparams_zol_without_sudo.conf --directory-prefix="$CONFIG_DIR" || { echo "Error: Failed to download userparams_zol_without_sudo file"; exit 1; }

# Smartctl
echo "zabbix ALL=(ALL) NOPASSWD:/usr/sbin/smartctl" > /etc/sudoers.d/zabbix-smartctl
echo "zabbix ALL=(ALL) NOPASSWD:/etc/zabbix/zabbix_agent2.d/smartctl_zabbix.sh" >> /etc/sudoers.d/zabbix-smartctl
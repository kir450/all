#!/bin/bash

# Обновление списка пакетов и установка необходимых пакетов
sudo apt install -y isc-dhcp-server iptables-persistent

# Настройка сетевых интерфейсов через netplan
cat <<EOL | sudo tee /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: yes
    eth1:
      addresses:
        - 192.168.1.1/24
    eth2:
      addresses:
        - 192.168.2.1/24
    eth3:
      addresses:
        - 192.168.3.1/24
EOL

# Применение изменений сетевой конфигурации
sudo netplan apply

# Настройка DHCP-сервера
cat <<EOL | sudo tee /etc/dhcp/dhcpd.conf
ddns-update-style none;
option domain-name "kir.int";
option domain-name-servers 8.8.8.8, 8.8.4.4;
default-lease-time 86400;
max-lease-time 604800;
authoritative;
log-facility local7;
subnet 192.168.1.0 netmask 255.255.255.0 {
  range 192.168.1.100 192.168.1.200;
  option routers 192.168.1.1;
}
subnet 192.168.2.0 netmask 255.255.255.0 {
  range 192.168.2.100 192.168.2.200;
  option routers 192.168.2.1;
}
subnet 192.168.3.0 netmask 255.255.255.0 {
  range 192.168.3.100 192.168.3.200;
  option routers 192.168.3.1;
}
EOL

# Перезапуск DHCP-сервера
sudo systemctl restart isc-dhcp-server

# Настройка IP-перенаправления
sudo sed -i '/^#net.ipv4.ip_forward=1/s/^#//g' /etc/sysctl.conf
sudo sysctl -p

# Настройка правил iptables для маскирования (NAT)
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -o eth2 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -o eth3 -j MASQUERADE
sudo iptables-save | sudo tee /etc/iptables/rules.v4

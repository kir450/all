#!/bin/bash

# Установка необходимых пакетов
sudo apt update
sudo apt install -y isc-dhcp-server iptables-persistent

# Настройка сетевых интерфейсов
sudo bash -c 'cat << EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

auto ens3
iface ens3 inet dhcp

auto ens4
iface ens4 inet static
    address 192.168.1.1
    netmask 255.255.255.0

auto ens5
iface ens5 inet static
    address 192.168.2.1
    netmask 255.255.255.0
EOF'

# Перезапуск сетевых служб
sudo service networking restart

# Настройка DHCP-сервера
sudo bash -c 'cat << EOF > /etc/dhcp/dhcpd.conf
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
EOF'

# Перезапуск DHCP-сервера
sudo systemctl restart isc-dhcp-server

# Настройка правил iptables для маскирования (NAT)
sudo iptables -t nat -A POSTROUTING -o ens3 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -o ens4 -j MASQUERADE

# Сохранение правил iptables
sudo iptables-save > /etc/iptables/rules.v4

# Применение изменений в IP-перенаправлении
sudo sysctl -p

# Настройка для автозапуска iptables-persistent
sudo systemctl enable netfilter-persistent
sudo netfilter-persistent save

echo "Настройки сети и DHCP успешно применены."

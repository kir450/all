#!/bin/bash

# Проверка наличия необходимых пакетов
if ! command -v iptables &> /dev/null || ! command -v sysctl &> /dev/null; then
    echo "Необходимые пакеты iptables или sysctl не установлены. Пожалуйста, установите их и повторите попытку."
    exit 1
fi

# Проверка существования сетевых интерфейсов
if ! ip link show ens3 &> /dev/null || ! ip link show ens4 &> /dev/null; then
    echo "Один или оба сетевых интерфейса (ens3, ens4) не существуют. Пожалуйста, проверьте конфигурацию сети."
    exit 1
fi

# Обновляем систему и устанавливаем DHCP-сервер
sudo apt update
sudo apt install isc-dhcp-server -y

# Настраиваем сетевые интерфейсы
cat <<EOL | sudo tee /etc/network/interfaces
auto lo
iface lo inet loopback

auto ens3
iface ens3 inet dhcp

auto ens4
iface ens4 inet static
   address 192.168.1.1
   netmask 255.255.255.0
EOL

# Включаем пересылку пакетов
sudo sed -i '/^#*net.ipv4.ip_forward/c\net.ipv4.ip_forward=1' /etc/sysctl.conf
sudo sed -i '/^#*net.ipv6.conf.all.forwarding/c\net.ipv6.conf.all.forwarding=1' /etc/sysctl.conf
sudo sysctl -p

# Настраиваем NAT для интерфейса ens3
sudo iptables -t nat -A POSTROUTING -o ens3 -j MASQUERADE

# Настраиваем DHCP-сервер
cat <<EOL | sudo tee /etc/dhcp/dhcpd.conf
subnet 192.168.1.0 netmask 255.255.255.0 {
   range 192.168.1.100 192.168.1.200;
   option routers 192.168.1.1;
   option domain-name-servers 8.8.8.8, 8.8.4.4;
   option domain-name "example.local";
}

host reserved-host {
    hardware ethernet AA:BB:CC:DD:EE:FF;
    fixed-address 192.168.1.150;
}
EOL

# Указываем интерфейс для isc-dhcp-server
sudo sed -i 's/^#*INTERFACESv4=.*/INTERFACESv4="ens4"/' /etc/default/isc-dhcp-server

# Перезапускаем службы
sudo systemctl restart networking
sudo systemctl enable isc-dhcp-server
sudo systemctl restart isc-dhcp-server

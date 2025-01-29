#!/bin/bash

# Обновляем систему и устанавливаем DHCP-сервер
sudo apt update
sudo apt install isc-dhcp-server -y

# Создаем резервную копию текущих настроек сетевых интерфейсов
sudo cp /etc/network/interfaces /etc/network/interfaces.backup

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

auto ens5
iface ens5 inet static
   address 192.168.2.1
   netmask 255.255.255.0

auto ens6
iface ens6 inet static
   address 192.168.3.1
   netmask 255.255.255.0

auto ens7
iface ens7 inet static
   address 192.168.4.1
   netmask 255.255.255.0

auto ens8
iface ens8 inet static
   address 192.168.5.1
   netmask 255.255.255.0
EOL

# Включаем пересылку пакетов
if grep -q '^net.ipv4.ip_forward' /etc/sysctl.conf; then
    sudo sed -i 's/^net.ipv4.ip_forward.*/net.ipv4.ip_forward=1/' /etc/sysctl.conf
else
    echo 'net.ipv4.ip_forward=1' | sudo tee -a /etc/sysctl.conf
fi

sudo sysctl -p

# Настраиваем NAT для интерфейса ens3
sudo iptables -t nat -A POSTROUTING -o ens3 -j MASQUERADE

# Устанавливаем iptables-persistent для сохранения правил
sudo apt install iptables-persistent -y
sudo netfilter-persistent save

# Настраиваем DHCP-сервер
sudo cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.backup

cat <<EOL | sudo tee /etc/dhcp/dhcpd.conf
# Настройка для сети ens4
subnet 192.168.1.0 netmask 255.255.255.0 {
   range 192.168.1.100 192.168.1.200;
   option routers 192.168.1.1;
   option domain-name-servers 8.8.8.8, 8.8.4.4;
   option domain-name "example.local";
}

# Настройка для сети ens5
subnet 192.168.2.0 netmask 255.255.255.0 {
   range 192.168.2.100 192.168.2.200;
   option routers 192.168.2.1;
   option domain-name-servers 8.8.8.8, 8.8.4.4;
   option domain-name "example.local";
}

# Настройка для сети ens6
subnet 192.168.3.0 netmask 255.255.255.0 {
   range 192.168.3.100 192.168.3.200;
   option routers 192.168.3.1;
   option domain-name-servers 8.8.8.8, 8.8.4.4;
   option domain-name "example.local";
}

# Настройка для сети ens7
subnet 192.168.4.0 netmask 255.255.255.0 {
   range 192.168.4.100 192.168.4.200;
   option routers 192.168.4.1;
   option domain-name-servers 8.8.8.8, 8.8.4.4;
   option domain-name "example.local";
}

# Настройка для сети ens8
subnet 192.168.5.0 netmask 255.255.255.0 {
   range 192.168.5.100 192.168.5.200;
   option routers 192.168.5.1;
   option domain-name-servers 8.8.8.8, 8.8.4.4;
   option domain-name "example.local";
}
EOL

# Указываем интерфейсы для isc-dhcp-server
sudo sed -i 's/INTERFACESv4=.*/INTERFACESv4="ens4 ens5 ens6 ens7 ens8"/' /etc/default/isc-dhcp-server

# Перезапускаем службы
sudo systemctl restart networking
sudo systemctl enable isc-dhcp-server
sudo systemctl restart isc-dhcp-server

echo "Скрипт выполнен. DHCP-сервер настроен для ens4, ens5, ens6, ens7 и ens8."

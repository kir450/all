#!/bin/bash

# Переменные
SHARE_NAME="share"
SHARE_PATH="/srv/samba/$SHARE_NAME"
GROUP_NAME="smbgroup"
USERS=("user1" "user2")

# Установка Samba
echo "Устанавливаем Samba..."
sudo apt update
sudo apt install -y samba

# Создание группы
echo "Создаем группу $GROUP_NAME..."
sudo groupadd $GROUP_NAME

# Создание пользователей и добавление в группу
for USER in "${USERS[@]}"; do
    echo "Создаем пользователя $USER..."
    sudo useradd $USER -m -G $GROUP_NAME
    echo "Установите пароль для $USER:"
    sudo passwd $USER
    echo "Добавляем пользователя $USER в Samba..."
    sudo smbpasswd -a $USER
    sudo smbpasswd -e $USER
done

# Создание папки для шары
echo "Создаем папку для шары $SHARE_PATH..."
sudo mkdir -p $SHARE_PATH

# Настройка разрешений для папки (только чтение)
echo "Настраиваем разрешения на папку..."
sudo chown root:$GROUP_NAME $SHARE_PATH
sudo chmod 550 $SHARE_PATH

# Настройка Samba
echo "Настраиваем Samba для расшаривания папки..."
sudo bash -c "cat >> /etc/samba/smb
::contentReference[oaicite:0]{index=0}
 

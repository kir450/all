#!/bin/bash

# Создание необходимых папок
sudo mkdir /home/Media
sudo mkdir /home/Tr

# Предоставление прав доступа
sudo chmod -R 777 /home/Media
sudo chmod -R 777 /home/Tr

# Установка Samba
sudo apt install samba

# Создание резервной копии конфигурационного файла Samba
sudo cp /etc/samba/smb.conf{,.backup}

# Редактирование конфигурационного файла Samba
sudo bash -c 'cat << EOF > /etc/samba/smb.conf
[global]
   workgroup = WORKGROUP
   server string = %h server (Samba, Ubuntu)
   netbios name = samba
   security = user
   map to guest = bad user
   idmap config * : backend = tdb

[Media]
   path = /home/Media
   browsable = yes
   writable = yes
   guest ok = yes
   guest only = yes
   read only = no
   create mask = 0777
   directory mask = 0777
   force create mode = 0777
   force directory mode = 0777

[Tr]
   path = /home/Tr
   browsable = yes
   writable = yes
   guest ok = yes
   guest only = yes
   read only = no
   create mask = 0777
   directory mask = 0777
   force create mode = 0777
   force directory mode = 0777
EOF
'

# Перезапуск службы Samba
sudo service smbd restart

echo "Установка и настройка Samba завершена."

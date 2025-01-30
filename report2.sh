#!/bin/bash

# Переменная с текущей датой и временем
data=$(date +%d.%m.%Y-%H:%M:%S)

# Путь для резервного копирования
backup_dir="/var/backup/$data"

# Создание директории для резервного копирования
if ! mkdir -p "$backup_dir"; then
    echo "Ошибка: не удалось создать директорию $backup_dir"
    exit 1
fi

# Функция для копирования директорий с проверкой
copy_dir() {
    src=$1
    dest=$2
    if [ -d "$src" ]; then
        cp -r "$src" "$dest"
        echo "Скопирована директория $src"
    else
        echo "Предупреждение: директория $src не найдена, пропуск"
    fi
}

# Копирование настроек
copy_dir "/etc/frr" "$backup_dir"
copy_dir "/etc/nftables" "$backup_dir"
copy_dir "/etc/NetworkManager/system-connections" "$backup_dir"
copy_dir "/etc/dhcp" "$backup_dir"

# Переход в директорию /var/backup
cd /var/backup || { echo "Ошибка: не удалось перейти в /var/backup"; exit 1; }

# Архивирование
if tar czfv "./$data.tar.gz" "./$data"; then
    echo "Архив $data.tar.gz успешно создан"
    # Удаление временной директории после успешного архивирования
    rm -r "$backup_dir"
else
    echo "Ошибка: не удалось создать архив"
    exit 1
fi

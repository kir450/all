#!/bin/bash

# Директория для резервных копий
BACKUP_DIR="/backups"

# Проверка существования директории и создание при необходимости
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
    if [ $? -ne 0 ]; then
        echo "$(date +"%Y-%m-%d %H:%M:%S") Ошибка: не удалось создать директорию $BACKUP_DIR." >> "$LOG_FILE"
        exit 1
    fi
fi

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/etc_backup_$TIMESTAMP.tar.gz"

# Логирование
LOG_FILE="$BACKUP_DIR/backup.log"

# Создание резервной копии
echo "$(date +"%Y-%m-%d %H:%M:%S") Начало резервного копирования..." >> "$LOG_FILE"

if tar -czf "$BACKUP_FILE" /etc 2>>"$LOG_FILE"; then
    echo "$(date +"%Y-%m-%d %H:%M:%S") Резервное копирование успешно завершено. Файл: $BACKUP_FILE" >> "$LOG_FILE"
else
    echo "$(date +"%Y-%m-%d %H:%M:%S") Ошибка резервного копирования!" >> "$LOG_FILE"
    exit 1
fi

# Удаление старых резервных копий (старше 7 дней)
find "$BACKUP_DIR" -type f -name "etc_backup_*.tar.gz" -mtime +7 -exec rm -f {} \;

echo "$(date +"%Y-%m-%d %H:%M:%S") Удалены старые резервные копии." >> "$LOG_FILE"

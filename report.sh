#!/bin/bash

# Путь к логам или задачам для отчета
LOG_FILE="/var/log/syslog"
BACKUP_DIR="/backups"
REPORT_FILE="$BACKUP_DIR/task_report_$(date +'%Y-%m-%d').log"

# Проверка и создание директории для отчета
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
fi

# Генерация отчета
echo "Отчет по выполненным задачам для $(date)" > "$REPORT_FILE"
echo "===============================" >> "$REPORT_FILE"
echo "Вывод системного лога:" >> "$REPORT_FILE"
tail -n 50 "$LOG_FILE" >> "$REPORT_FILE"

# Отправка отчета на email
SUBJECT="Еженедельный отчет по задачам"
EMAIL="your-email@example.com"
mail -s "$SUBJECT" "$EMAIL" < "$REPORT_FILE"

# Очистка временного файла отчета
rm "$REPORT_FILE"

# Проверка наличия команды mail: 
# Убедитесь, что в системе установлена утилита mail с помощью пакета mailutils:

#!/bin/bash

# 1. Запуск встроенной утилиты резервного копирования FreeIPA
ipa-backup

# 2. Поиск созданного архива ( FreeIPA сохраняет бэкап как ipa-full-YYYY-MM-DD-HH-MM-SS )
LATEST_BACKUP_DIR=$(ls -dt /var/lib/ipa/backup/ipa-full-* | head -n 1)

if [ -z "$LATEST_BACKUP_DIR" ]; then
    exit 1
fi

# 3. Формирование имени файла с текущей меткой времени в формате YYYY-MM-DD
DATE_STR=$(date +%Y-%m-%d)
ARCHIVE_NAME="ipa_backup_${DATE_STR}.tar.gz"

tar -czf "/home/user/scripts/${ARCHIVE_NAME}" -C "$(dirname "$LATEST_BACKUP_DIR")" "$(basename "$LATEST_BACKUP_DIR")"

# 4. Передача архива на сервер филиала FS_BR
scp "/home/user/scripts/${ARCHIVE_NAME}" user@fs-br:/data/backups/

# Очистка локального архива
rm -f "/home/user/scripts/${ARCHIVE_NAME}"

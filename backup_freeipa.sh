#!/bin/bash

# 1. Запуск встроенной утилиты резервного копирования FreeIPA
ipa-backup

# 2. Перемещение и архивация полученных файлов данных и метаданных в монолитный .tar.gz архив
# (по умолчанию ipa-backup сохраняет бэкапы в /var/lib/ipa/backup/)
LATEST_BACKUP_DIR=$(ls -dt /var/lib/ipa/backup/ipa-backup-* | head -n 1)

if [ -z "$LATEST_BACKUP_DIR" ]; then
    exit 1
fi

# 3. Формирование имени файла с текущей меткой времени в строгом системном формате YYYY-MM-DD
DATE_STR=$(date +%Y-%m-%d)
ARCHIVE_NAME="ipa_backup_${DATE_STR}.tar.gz"

tar -czf "/home/user/scripts/${ARCHIVE_NAME}" -C "$(dirname "$LATEST_BACKUP_DIR")" "$(basename "$LATEST_BACKUP_DIR")"

# 4. Передача архива по протоколу SCP на сервер хранения филиала FS_BR
# Предварительно настройте авторизацию по SSH-ключам для беспарольного доступа
scp "/home/user/scripts/${ARCHIVE_NAME}" user@fs-br:/data/backups/

# Очистка локального архива (опционально)
rm -f "/home/user/scripts/${ARCHIVE_NAME}"

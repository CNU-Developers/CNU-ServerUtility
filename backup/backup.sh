#!/bin/bash

BACKUP_FILES_DIRECTORY="/root/backup_disk/backups"
BACKUP_RESULT_DIRECTORY="/root/backup_disk"

args=""
declare -a backups
idx=0

if [ -f $BACKUP_FILES_DIRECTORY ]; then
	echo "[Error] $BACKUP_FILES_DIRECTORY is a file!"
	exit 1
elif [ ! -e $BACKUP_FILES_DIRECTORY ]; then
	echo "[*] Make Directory $BACKUP_FILES_DIRECTORY"
	mkdir $BACKUP_FILES_DIRECTORY
fi

echo "[*] Compress user's home directories in ${BACKUP_FILES_DIRECTORY}/"
for dir in /home/*
do
	username=`basename "$dir"`
	echo "[*] Backup-ing ${username}'s directories"
	tar -cvzPf "${BACKUP_FILES_DIRECTORY}/cnupro-${username}.tar.gz" "$dir" 1>/dev/null
	backups[$idx]="${BACKUP_FILES_DIRECTORY}/cnupro-${username}.tar.gz"
	args="$args \"\${backups[$idx]}\""
	idx=`expr $idx + 1`
done

echo "[*] Compress user's backup files to one backup file in /root/"
eval "tar -cvzf ${BACKUP_RESULT_DIRECTORY}/all-cnupro.tar.gz $args 1>/dev/null"

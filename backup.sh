#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/.env

if (( "$#" == "1" )); then
  echo "Opening share"
  ${SCRIPT_DIR}/.venv/bin/python ${SCRIPT_DIR}/share-control.py true
  echo "Share opened, now mounting"
  mount ${REMOTE_BACKUP_PATH}
  echo "mounted"
  date_iso=$(date --iso-8601)
  echo "${LOCAL_BACKUP_PATH}/${date_iso}-bwdata.tar.gz"
  echo "now compressing"
  tar -czvf "${LOCAL_BACKUP_PATH}/${date_iso}-bwdata.tar.gz" ${BITWARDEN_PATH}
  echo "compression done, now copying to share"
  rsync --progress "${LOCAL_BACKUP_PATH}/${date_iso}-bwdata.tar.gz" "${REMOTE_BACKUP_PATH}/${date_iso}-bwdata.tar.gz"
  echo "copy over now deleting old version"
  echo "now deleting local backup from 2 weeks ago"
  date_iso_2w=$(date --iso-8601 --date="2 week ago")
  rm ${LOCAL_BACKUP_PATH}/${date_iso_2w}-bwdata.tar.gz
  echo "deleted local backup, now deleting remote backup from 2 month ago"
  date_iso_2m=$(date --iso-8601 --date="2 month ago")
  rm ${REMOTE_BACKUP_PATH}/${date_iso_2m}-bwdata.tar.gz
  echo "deletion deleted, now waiting for potential sync delay"
  sleep 15s
  echo "30s to go"
  sleep 15s
  echo "15s to go"
  sleep 15s
  echo "wait over"
  echo "now unmounting"
  umount ${REMOTE_BACKUP_PATH}
  echo "unmounted, now closing share"
  ${SCRIPT_DIR}/.venv/bin/python ${SCRIPT_DIR}/share-control.py false
  echo "share closed, backup over"
  echo "all completed."
else
  ${SCRIPT_DIR}/.venv/bin/python ${SCRIPT_DIR}/share-control.py  true
  mount ${REMOTE_BACKUP_PATH}
  date_iso=$(date --iso-8601)
  tar -czf "${LOCAL_BACKUP_PATH}/${date_iso}-bwdata.tar.gz" ${BITWARDEN_PATH}
  rsync "${LOCAL_BACKUP_PATH}/${date_iso}-bwdata.tar.gz" "${REMOTE_BACKUP_PATH}/${date_iso}-bwdata.tar.gz"
  date_iso_2w=$(date --iso-8601 --date="2 week ago")
  rm ${LOCAL_BACKUP_PATH}/${date_iso_2w}-bwdata.tar.gz
  date_iso_2m=$(date --iso-8601 --date="2 month ago")
  rm ${REMOTE_BACKUP_PATH}/${date_iso_2m}-bwdata.tar.gz
  sleep 45s
  umount ${REMOTE_BACKUP_PATH}
  ${SCRIPT_DIR}/.venv/bin/python ${SCRIPT_DIR}/share-control.py false
fi

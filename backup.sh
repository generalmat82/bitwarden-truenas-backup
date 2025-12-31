#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/.env

if (( "$#" == "1" )); then
  echo "Opening share"
  ${SCRIPT_DIR}/bin/python ${SCRIPT_DIR}/websocket-test.py true true
  echo "Share opened, now mounting"
  mount ${remoteBackupPath}
  echo "mounted"
  date_iso=$(date --iso-8601)
  echo "${localBackupPath}/${date_iso}-bwdata.tar.gz"
  echo "now compressing"
  tar -czvf "${localBackupPath}/${date_iso}-bwdata.tar.gz" ${bitwarden_path}
  echo "compression done, now copying to share"
  rsync --progress "${localBackupPath}/${date_iso}-bwdata.tar.gz" "${remoteBackupPath}/${date_iso}-bwdata.tar.gz"
  echo "copy over, now waiting for potential sync delay"
  sleep 15s
  echo "30s to go"
  sleep 15s
  echo "15s to go"
  sleep 15s
  echo "wait over"
  echo "now unmounting"
  umount ${remoteBackupPath}
  echo "unmounted, now closing share"
  ${SCRIPT_DIR}/bin/python ${SCRIPT_DIR}/websocket-test.py false true
  echo "share closed, backup over"
  echo "now deleting local backup from 2 weeks ago"
  date_iso_2w=$(date --iso-8601 --date="2 week ago")
  rm ${localBackupPath}/${date_iso_2w}-bwdata.tar.gz
  echo "deleted, all completed."
else
  ${SCRIPT_DIR}/bin/python ${SCRIPT_DIR}/websocket-test.py  true false
  mount ${remoteBackupPath}
  date_iso=$(date --iso-8601)
  tar -czvf "${localBackupPath}/${date_iso}-bwdata.tar.gz" ${bitwarden_path}
  rsync "${localBackupPath}/${date_iso}-bwdata.tar.gz" "${remoteBackupPath}/${date_iso}-bwdata.tar.gz"
  sleep 45s
  umount ${remoteBackupPath}
  ${SCRIPT_DIR}/bin/python ${SCRIPT_DIR}/websocket-test.py false false
  date_iso_2w=$(date --iso-8601 --date="2 week ago")
  rm ${localBackupPath}/${date_iso_2w}-bwdata.tar.gz
fi

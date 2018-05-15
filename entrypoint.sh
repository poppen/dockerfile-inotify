#!/bin/sh
set -euo pipefail

SIGNAL=${SIGNAL:-"SIGHUP"}
INOTIFY_EVENTS=${INOTIFY_EVENTS:-"create,delete,modify,move"}
INOTIFY_OPTONS=${INOTIFY_OPTONS:-"-r"}
INOTIFY_EXCLUDE_PATTERN=${INOTIFY_EXCLUDE_PATTERN:-"\.sw[pox]$|.*~$|.*\.bak$|\.git/.*"}
INOTIFY_OUTPUT_FORMAT=${INOTIFY_OUTPUT_FORMAT:-"%w%f"}
INOTIFY_COMMAND=${INOTIFY_COMMAND:-'echo $FILE'}
VOLUMES=${VOLUMES:-"/data"}

inotifywait -e "${INOTIFY_EVENTS}" -m ${INOTIFY_OPTONS} --exclude="${INOTIFY_EXCLUDE_PATTERN}" "${VOLUMES}" --format "${INOTIFY_OUTPUT_FORMAT}" | \
while read -r FILE; do
    eval "${INOTIFY_COMMAND}"
done

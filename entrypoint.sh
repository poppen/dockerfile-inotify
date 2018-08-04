#!/bin/sh
set -eu

SIGNAL=${SIGNAL:-"SIGHUP"}
INOTIFY_EVENTS=${INOTIFY_EVENTS:-"close_write,delete,move"}
INOTIFY_OPTONS=${INOTIFY_OPTONS:-"-r"}
INOTIFY_EXCLUDE_PATTERN=${INOTIFY_EXCLUDE_PATTERN:-"\.sw[pox]$|.*~$|.*\.bak$|\.git/.*"}
INOTIFY_OUTPUT_FORMAT=${INOTIFY_OUTPUT_FORMAT:-"%w%f"}
INOTIFY_SCRIPT_DIR=${INOTIFY_SCRIPT_DIR:-"/inotify.d"}
VOLUMES=${VOLUMES:-"/data"}

inotifywait -e "${INOTIFY_EVENTS}" -m ${INOTIFY_OPTONS} --exclude="${INOTIFY_EXCLUDE_PATTERN}" "${VOLUMES}" --format "${INOTIFY_OUTPUT_FORMAT}" | \
    while read -r FILE; do
        if [ -d "${INOTIFY_SCRIPT_DIR}" ]; then
            for f in "${INOTIFY_SCRIPT_DIR}"/*; do
                if [ -x "$f" ]; then
                    echo "Running $f ..."
                    $f "$FILE"
                else
                    echo "Could not run $f, because it's missing execute permission (+x)." >&2
                fi
            done
            unset f
        fi
    done

#!/bin/sh
# nightly-backup.sh — recipe 1, chapter 12.
# Absolute paths everywhere: cron's environment is not your shell's.
set -u
export RESTIC_REPOSITORY=/mnt/usb/backups/home-repo
export RESTIC_PASSWORD_FILE=$HOME/.restic-password

# Stop loudly rather than back up to the wrong place (chapter 15).
[ -d "$RESTIC_REPOSITORY" ] || { echo "repository not mounted" >&2; exit 1; }

restic backup --tag nightly "$HOME/documents" "$HOME/photos" \
  --exclude-file "$HOME/.restic-excludes" || exit 1
restic forget --tag nightly --keep-daily 7 --keep-weekly 4 \
  --keep-monthly 6 || exit 1
# Prune weekly, not nightly — it is the expensive step (chapter 9).
[ "$(date +%u)" = 7 ] && { restic prune || exit 1; }
restic check || exit 1

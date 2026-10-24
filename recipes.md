# Recipes

Four arrangements that cover most real
setups. Each names its backend honestly:
the *commands* are the ones the lab
verified; the remote backends are chapter
11's documented-only territory, so build
the local shape first and change the
address when the local one works.

## 1. A home folder, nightly, to a USB drive

The smallest setup that deserves the name
backup. The password sits in a file only
you can read; the scheduler is cron; the
script is the whole system:

```bash
#!/bin/sh
# nightly-backup.sh — see examples/
export RESTIC_REPOSITORY=/mnt/usb/backups/home-repo
export RESTIC_PASSWORD_FILE=$HOME/.restic-password
restic backup --tag nightly $HOME/documents $HOME/photos \
  --exclude-file $HOME/.restic-excludes
restic forget --tag nightly --keep-daily 7 --keep-weekly 4 --keep-monthly 6
restic check
```

Run it by hand until it bores you, then
let cron run it (`15 2 * * *`). Two habits
make it a system rather than a script:
forget without prune nightly, and let a
weekly run add `restic prune` — and treat
any non-zero exit as a message to a human,
not a line in a log nobody opens.

## 2. Photographs to a second machine

The family archive to the household
server, over SFTP
(`-r sftp:you@server:/srv/backups/photos`),
tagged `photos`, excluded by an
excludes file that leaves the camera's
sidecar junk behind. Photographs are
nearly pure gain for deduplication across
*folders* — the same image filed three
ways is stored once — and nearly pure
loss for compression; budget the
repository at roughly the archive's size
plus its annual growth, not at a hopeful
ratio. Verify the first big restore by
checksum (chapter 8) before deleting
anything from anywhere.

## 3. A small server's data to object storage

Dump first, then back up the dump:

```bash
mysqldump --single-transaction myapp > /var/backups/myapp.sql
restic -r s3:my-bucket/myapp backup --tag nightly /var/backups /etc/myapp
```

The principle is older than restic: back
up *products* (a dump, an export, a closed
file), not a live database's working
files. The same shape works for any
application that can write a consistent
export. Object storage's per-request
metering argues for fewer, larger runs —
nightly, not hourly, unless the data
earns it.

## 4. The rehearsal restore, monthly

Not a backup arrangement: a calendar
appointment, for whichever of the above
you built. Restore last month's snapshot
to a scratch folder, `diff -r` it or
checksum a sample, delete the scratch.
Ten minutes, four times a year minimum.
Chapter 8 exists so that this recipe is
muscle memory rather than research, and
the month the rehearsal *fails* is the
month it pays for every previous one.

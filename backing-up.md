# Backing Up

One command does the work:

```bash
restic backup /path/to/what/matters
```

You may name several paths, and you run it
from anywhere — restic records the paths
as given, and a snapshot always shows the
absolute path it came from. Run it the
first time and read the summary properly;
it is the template for every later run
(transcript `t02`, the lab's invented
`field-notes` folder):

```
Files:           5 new,     0 changed,     0 unmodified
Dirs:            9 new,     0 changed,     0 unmodified
Added to the repository: 12.006 MiB (12.005 MiB stored)
processed 5 files, 12.000 MiB in 0:03
snapshot c81c812b saved
```

Four things to take from that output:

- **The snapshot ID** (`c81c812b`) is the
  short name every later command accepts.
  The full ID exists; the short one is
  unique in practice and restic says so if
  it ever is not.
- **"Added to the repository"** is the
  honest cost of this backup: the new data
  actually stored, after deduplication and
  compression, with the stored size in
  brackets. Watch this number, not the
  size of the folder — chapter 6 is built
  on the difference.
- **New, changed, unmodified** is restic
  comparing against the **parent
  snapshot**: the previous snapshot of the
  same paths on the same host. Unchanged
  files are recognised from the parent's
  tree without re-reading their contents,
  which is why nightly backups of a big
  tree are quick. Change the paths or the
  host and there is no parent — restic
  says "no parent snapshot found, will
  read all files", reads everything once,
  and is fast again from then on.
- Nothing here asked a question. Backup is
  built to be scripted: no prompts, a
  meaningful exit code, and a summary a
  log file can keep.

## Saying what to leave out

Backing up a home folder verbatim means
backing up caches, thumbnails, and build
output. Excludes fix that:

```bash
restic backup --exclude-file excludes.txt ~/documents
```

One pattern per line in the file (the
lab's `examples/excludes.txt`):

```
*.tmp
cache/
```

Patterns match against the path; a name
ending in `/` leaves out a whole folder
and everything under it. The lab verified
its excludes the blunt way — the excluded
file was created, the backup ran, and the
snapshot was searched for it (transcript
`t09`):

Check: the count comes back `0` — the file
is simply not in the snapshot. Trust
excludes only after a check like that;
a pattern that matches nothing fails
silently and backs the junk up anyway.

The usual first excludes for a home folder:
browser and application caches, `*.tmp`,
thumbnail folders, `node_modules` and
other build output you can recreate, and
— on a machine that also syncs — the sync
tool's own conflict copies.

## Tags: labels you will thank yourself for

```bash
restic backup --tag fieldnotes --tag weekly ~/field-notes
```

Tags are free-text labels on the snapshot.
They look decorative until retention time
(chapter 9), when "keep the weeklies for a
year, the dailies for a month" becomes a
policy restic can apply — by tag, by host,
by path. Tag by purpose, consistently,
from the first snapshot: renaming history
later is possible (`restic tag`) but
nobody enjoys it. The lab's tagged backup
is transcript `t09`; its snapshots list
shows the tags beside the snapshot they
belong to.

## Exit codes are part of the design

A backup that partially failed — one file
locked, one folder unreadable — exits
non-zero and says which file and why. A
scheduler that ignores exit codes will
hide exactly the failures you run backups
to survive. Chapter 12's recipe script
treats any non-zero exit as "tell a human",
which is the whole point of automating
this at all.

# Restic for Mere Mortals

Almost everyone's backup plan, stated
honestly, is a folder they copy to a drive
when they remember, or a sync tool that
mirrors their deletions as faithfully as
their files. **Restic** is the open-source
program that replaces both with something
defensible: a single command-line tool
that takes **snapshots** of what matters
into a repository that is **encrypted**
with a password only you hold,
**deduplicated** so that a month of daily
snapshots costs little more than one, and
**checkable**, so that "the backup works"
is a command you ran rather than a feeling
you have. This guide explains how it
works, takes a first repository from
creation to a rehearsed restore, and is
careful about the two facts the whole
subject turns on: history is cheap when
chunks are shared, and a lost password is
lost data.

The lab behind this guide ran the real
thing: **restic 0.18.1**, the project's
current release on build day, as the
official single binary on Ubuntu. Against
an invented `field-notes` folder — diaries,
lists, a spreadsheet, and two binary
"photographs" — it did the whole round
trip and kept the receipts: a repository
initialised, a first backup of 12 MiB, a
second backup of a 20 MiB tree that grew
the repository by about five *kilobytes*
because the new photograph was a copy of
an old one, snapshots listed, diffed, and
searched, a restore verified against
checksums written down before the backup
was taken, an old snapshot forgotten, the
prune that swept its leavings measured to
the blob, a full `--read-data` check, and
the flat refusal of a wrong password.
What the lab could not do, it did not
fake: the repository and its data lived
on the same machine, which no real setup
should imitate, and the network backends
— SFTP, the REST server, object storage —
are taught from the project's own
documentation and labelled documented-only
wherever they appear. `criteria.md` keeps
the ledger of what was run and what was
only read.

## What this guide covers

- [**What Restic is**](what-restic-is.md) —
  encrypted, deduplicated, checkable
  snapshots; what it is not (sync, an
  imager, a database tool, a daemon)
- [**The moving parts**](the-moving-parts.md) —
  chunks, blobs and packs; snapshots and
  trees; why the password is not the key;
  backends, cache and locks
- [**Installing Restic**](installing-restic.md) —
  one static binary; the package versus
  the official download; what the lab ran
- [**Your first repository**](your-first-repository.md) —
  where a repository should live, the
  three ways of handing restic its
  password, and the warning printed at
  creation that is literally true
- [**Backing up**](backing-up.md) — the
  backup command read properly, parent
  snapshots, excludes you have verified,
  and tags that pay off at retention time
- [**Snapshots and deduplication**](deduplication.md) —
  the proof chapter: 8 MiB of new data,
  five kilobytes of growth, and what
  deduplication is not
- [**Looking inside**](looking-inside.md) —
  listing and walking snapshots, `diff`,
  `find`, and the two meanings of a
  repository's size
- [**Restoring**](restoring.md) — restoring
  whole and in part, verifying with
  `diff -r` and checksums, and the
  ownership warnings the lab met honestly
- [**Forgetting and pruning**](forgetting-and-pruning.md) —
  retention policies, why `forget` frees
  almost nothing, and what `prune`
  actually sweeps
- [**Checking and repair**](checking-and-repair.md) —
  the two depths of `check`, what repair
  can and cannot fix, and the three-line
  transcript of a wrong password
- [**Backends in brief**](backends-in-brief.md) —
  local (ran), and SFTP, REST server and
  object storage (documented only, and
  labelled) — plus the second-copy rule
- [**Recipes**](recipes.md) — a home
  folder to a USB drive, photographs to a
  second machine, a server's dumps to
  object storage, and the monthly
  rehearsal restore
- [**The neighbours**](the-neighbours.md) —
  BorgBackup, Duplicati, rsync snapshots,
  rclone, sync tools and the rest, with
  their honest trades
- [**Limits**](limits.md) — the absolute
  password, live databases, the missing
  scheduler, prune's cost, and the rest,
  stated plainly
- [**Troubleshooting**](troubleshooting.md) —
  the wrong-password fatal, the exit-1
  restore that lost nothing, the prune
  that freed nothing, stale locks, and
  cron's missing environment
- [**Glossary**](glossary.md) — the terms,
  collected in one place

## What it doesn't cover

Whole-machine bare-metal recovery (restic
restores files; chapter 14 explains the
division of labour), backing up other
people's cloud accounts, and the
operational security of exposing storage
to the internet — rest-server and object
storage are described, but hardening them
is a subject of its own. Building restic
from source and contributing to it are
the project's own documentation's job.

## How to use this guide

Read chapters 1 and 2 before touching
anything: the snapshot model and the
chunk mechanism explain every later
surprise in advance, including the two
that feel like bugs (a nearly-free second
backup, a prune that frees nothing).
Chapter 4's password decisions deserve
their five slow minutes — they are the
only irreversible ones in the book. Take
chapter 6's experiment as the standard of
proof for your own setup: change a file,
back up, and watch what the repository
counted. And do chapter 8's rehearsal
restore while the data is still a sample:
the guide's own restore produced warnings
worth understanding on a folder that did
not matter. The lab's transcripts live in
`restic-lab/transcripts/`; its notes are
`examples/lab-notes.txt`.

---

## Part of the series

This guide is one of the [For Mere Mortals](https://paulsullivan33-dev.github.io/mere-mortals/) guides: plain-language guides to the tools programmers and makers use.

Related guides:

- [Backups for Mere Mortals](https://paulsullivan33-dev.github.io/backups-for-mere-mortals/)
- [rclone for Mere Mortals](https://paulsullivan33-dev.github.io/rclone-for-mere-mortals/)
- [ZFS for Mere Mortals](https://paulsullivan33-dev.github.io/zfs-for-mere-mortals/)

## License

The writing in this guide is licensed under [CC BY 4.0](https://github.com/paulsullivan33-dev/restic-for-mere-mortals/blob/main/LICENSE). Code examples and lab scripts are licensed under the [MIT License](https://github.com/paulsullivan33-dev/restic-for-mere-mortals/blob/main/LICENSE-CODE).

# What Restic Is

Restic is a backup program: a single
command-line tool that copies your files
into a **repository** — a store it manages —
in a way that is encrypted, deduplicated,
and checkable. It is free, open-source
software, written in Go, and it runs on
Linux, Windows, and macOS from one binary
with no server of its own to install. The
repository can live on a disk in the same
machine, a disk in another room, or
somebody else's storage reached over the
network. Restic neither knows nor cares
which; it treats them all as places that
hold files.

Three words in that first paragraph do the
real work, and the whole guide hangs off
them:

- **Encrypted.** Everything in the
  repository is encrypted with a key derived
  from a password you choose at creation.
  Whoever holds the repository files holds
  ciphertext. Without the password, the
  backups are unreadable — including to
  you, a fact chapter 10 treats with the
  seriousness it deserves.
- **Deduplicated.** Restic cuts files into
  chunks and stores each distinct chunk
  once. Backing up the same photograph in
  two folders, or the same nearly-unchanged
  document on thirty successive nights,
  costs the repository almost nothing after
  the first copy. Chapter 6 proves this
  with numbers from the lab, not adjectives.
- **Checkable.** A repository can be
  verified: `restic check` reads its
  structures, and with `--read-data` it
  re-reads and re-validates the stored data
  itself. A backup you have never tested
  is a hope; restic at least gives you the
  test.

## Snapshots, not copies

Each run of `restic backup` produces a
**snapshot**: a complete, browsable picture
of the folders you backed up at that
moment. Snapshots feel like full copies —
you can list one, walk through it, restore
any file from it — while physically sharing
almost all of their data with the snapshots
before and after them. That combination,
full-picture semantics on shared storage,
is the thing older copy-the-folder backup
habits cannot do, and it changes what is
practical: keeping a snapshot a night for
months stops being a storage problem.

## Who it is for

Anyone whose current backup plan is "copy
the folder to the external drive when I
remember", or a sync tool quietly mirroring
deletions as faithfully as files. Restic
suits a home folder going to a USB drive, a
photo library going to a second machine
over SSH, a small server's data going to
object storage — the same tool and the same
commands at each scale. It asks you to be
comfortable at a command line, and it asks
you to keep one password safe. In exchange
it does not ask for an account, a
subscription, or trust in anyone's cloud.

## What it is not

- **Not synchronisation.** Sync tools
  (Syncthing, Dropbox, `rsync` without
  history) make two places the same,
  including the mistakes. Restic keeps
  history: yesterday's mistake does not
  overwrite last week's good copy.
- **Not a disk imager.** It backs up files
  and folders, not bootable whole-machine
  images. Restoring a system means
  reinstalling the system and restoring
  its files — a workable plan, but a
  different one.
- **Not a database backup tool by itself.**
  It faithfully copies a live database's
  files, which may not be a consistent
  database. Dump first, then back up the
  dump — chapter 12's recipes say how.
- **Not set-and-forget.** It has no daemon
  and no schedule of its own; your system's
  scheduler (cron, systemd timers, Task
  Scheduler) runs it. And its pruning and
  checking only happen when something
  runs them.
- **Not anonymous magic.** The encryption
  is strong and the design is public, but
  the password is a single point of total
  failure. Chapter 4 starts there for a
  reason.

## The one-sentence version

If your files matter, restic turns "copy
them somewhere, sometimes" into encrypted,
deduplicated snapshots you can browse,
restore from, and verify — for the price
of learning a dozen commands and guarding
one password.

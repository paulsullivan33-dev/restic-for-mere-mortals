# Troubleshooting

Symptom first, then the cause the lab or
the documentation supports, then the fix.
Every entry here except the last two was
met in this guide's own lab.

## "Fatal: wrong password or no key found"

**Cause:** the password offered does not
open any key in the repository — a typo, a
stale password file after a password
change, or the wrong repository path
entirely (chapter 10, transcript `t08`).
**Fix:** check `RESTIC_REPOSITORY` first
(it is embarrassing how often that is it),
then the password source. If the password
is truly lost, no fix exists; say so
plainly and start the new repository
early rather than late.

## The restore finished, exit 1, and the log is full of "operation not permitted"

**Cause:** ownership. The lab restored as
a user the sandbox would not let assign
file ownership, and got one `lchown` error
per file — with every file's contents
restored perfectly (transcript `t05`).
**Fix:** decide whether you care. Verify
the contents (`diff -r`, checksums —
chapter 8) before panicking; restore as
the owning user, or accept your own
ownership on the restored tree, when you
do. Exit 1 means "read the output", not
"the data is gone".

## "forget" ran, prune ran, and almost nothing was freed

**Cause:** arithmetic, not failure. The
forgotten snapshots' data was almost all
shared with the survivors; the lab's
prune removed 9 blobs (chapter 9,
transcript `t06`).
**Fix:** none. Check with
`restic stats --mode raw-data` before and
after if you want to watch it happen, and
revise the expectation: retention thins
history, deduplication already did the
shrinking.

## A backup is suddenly slow and reads everything

**Cause:** no parent snapshot matched —
the paths changed, the host name changed,
or the repository was re-created — so
restic says "no parent snapshot found,
will read all files" and means it.
**Fix:** keep paths and host naming
stable in scripts; the next run against
the new parent is fast again. A one-off
cause needs no repair at all.

## "repository is already locked" — and nothing is running

**Cause:** a restic process died (power,
closed laptop, killed terminal) and left
its lock. First confirm with your own
eyes that no restic process anywhere has
this repository open — two writers are
what the lock exists to prevent.
**Fix:** `restic unlock` removes stale
locks. Running it while another machine
*is* mid-backup is how repositories get
the damage chapter 10 exists to check
for, so the confirmation is the fix's
first half, not a formality.

## The snapshot does not contain the file you excluded "just to test"

That is the exclude working (chapter 5,
transcript `t09`) — the dangerous
direction is the opposite: a pattern that
matches nothing and excludes nothing,
silently. Patterns are matched against
paths as restic prints them in
`restic ls`; test an exclude file against
one backup and grep the snapshot before
trusting it in a schedule.

## Backup works interactively, fails under cron

**Cause:** the environment, almost always:
cron has no `RESTIC_PASSWORD` in your
shell profile, a relative path for the
password file or excludes file resolves
somewhere else, or the external drive is
not mounted yet at 2 a.m.
**Fix:** absolute paths for everything in
scripts, the password via
`RESTIC_PASSWORD_FILE`, and a line near
the top of the script that tests the
repository path exists and stops loudly
when it does not. Chapter 12's recipe is
written that way on purpose.

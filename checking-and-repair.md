# Checking and Repair

A backup system earns trust in two ways:
it notices damage, and it says so loudly.
This chapter is about restic's noticing —
and about the one kind of damage no check
can fix.

## The two depths of check

```bash
restic check
restic check --read-data
```

Plain `check` verifies the repository's
structure: indexes against packs, packs
against their own hashes, snapshots and
trees complete and consistent. It is fast
because it reads metadata and pack
headers, not your data.

`--read-data` goes all the way: it reads
every pack, decrypts every blob, and
verifies each hash. On a big repository
that is a full read of everything you
have — slow, and the only check that
proves the data itself is still good.
Middle options exist (`--read-data-subset`
checks a rotating fraction), which suit a
weekly schedule that covers the whole
repository across a month. The lab ran
both depths against its small repository
(transcript `t07`); both ended with the
sentence you are hoping to read:

```
no errors were found
```

Run the plain check often — after every
prune is a good habit — and `--read-data`
on a schedule you will actually keep.
A check that finds an error is not a
disaster; it is the system working. The
disaster is the error that had been there
for months, in the only copy, found on
restore day.

## When check complains

Restic's repair commands exist and are
named honestly: `restic repair index`,
`restic repair snapshots`, and `prune`
itself heals some index damage by
rebuilding. Their shared limit deserves
emphasis: **repair fixes structure, not
missing data.** If a pack is gone or a
blob fails its hash, no command invents
the contents. What saves you then is the
boring architecture around restic — the
repository living on storage with its own
redundancy or scrubbing, or a second
repository (`restic copy` keeps one in
step with another), so that "damaged"
describes one copy of two. Repair
commands are documented-only in this
guide: the lab damaged nothing, and
inventing damage to rehearse on would
have proven less than it risked.

## The failure with no repair

Transcript `t08` is three lines long:

```
$ RESTIC_PASSWORD set to a deliberately wrong value; restic snapshots
Fatal: wrong password or no key found
```

Every command against a repository starts
by opening a key with your password; a
wrong one stops there, before any data is
read. There is no hint system, no reset,
no support line. This is chapter 4's
warning with its shoes on: **a lost
password is lost data**, recoverable only
from wherever you wrote the password down.

Two softer versions of the same trap are
worth avoiding:

- **One password, changed carelessly.**
  `restic key passwd` re-wraps the master
  key safely (chapter 2), but scripts and
  schedules holding the old password fail
  from that moment, all at once, in the
  middle of the night. Update the stored
  password everywhere in the same sitting.
- **Several keys, none labelled.** `restic
  key list` shows keys by ID, user, and
  host; when you add one for a person or a
  machine, note which ID is whose while
  you still remember. Removing a key
  (`restic key remove`) revokes that
  password's access — and only works while
  another key still opens the repository,
  for obvious reasons.

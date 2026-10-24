# Backends in Brief

A **backend** is how restic reaches the
place the repository lives. The repository
format is identical everywhere; only the
address changes, given with `-r` or the
`RESTIC_REPOSITORY` variable. The lab ran
the local backend for every chapter.
Everything beyond it in this chapter is
**documented only** — described from the
project's documentation, labelled as such,
and not exercised by the lab. Treat the
commands as starting points to verify
against the current manual, not as
transcripts.

## Local (ran in the lab)

```
-r /path/to/repo
-r /mnt/usb-drive/backups
```

A folder on a mounted filesystem: an
internal disk, a USB drive, a network
share you mounted yourself. Simple, fast,
and entirely your problem to mount and
unmount. The right choice for a first
repository and for one of your copies at
any scale.

## SFTP (documented only)

```
-r sftp:you@server:/path/to/repo
```

Reaches a repository over SSH, using your
existing keys and accounts — no extra
service on the server beyond SSH itself,
and restic can create the remote folder
with `restic init` as usual. The natural
choice when the "somewhere else" of
chapter 4 is another machine you own:
a home server, a NAS that allows SSH, a
small rented server. Bandwidth and the
far machine's disk are the limits; prune
in particular moves real data, so schedule
it kindly.

## REST server (documented only)

```
-r rest:http://server:8000/repo
```

The project publishes a companion program,
**rest-server**, that speaks HTTP to
restic and stores repositories on the
server's disk. Two reasons to prefer it
over raw SFTP: it can be run in
**append-only** mode, where a client may
add backups but cannot delete or rewrite
existing data — a property that blunts
ransomware and fat-finger accidents alike,
since the backup machine's credentials
cannot destroy the history — and it is
usually faster than SFTP. The cost is one
more service to run and secure (TLS and
its own user accounts are the operator's
job).

## Object storage (documented only)

```
-r s3:bucket-name/path
-r b2:bucket-name/path
```

S3 and S3-compatible services, Backblaze
B2, Azure Blob, and Google Cloud Storage
are all supported, with credentials given
through each provider's usual environment
variables. This is other people's disks:
durable, off-site by definition, and
metered — every prune and `--read-data`
check moves data you may be paying to
move. The encryption earns its keep here
most of all; the provider stores chunks it
cannot read, keyed by hashes it cannot
reverse.

## Choosing, in one table

| Situation | Sensible first choice |
|---|---|
| One machine, one external drive | Local |
| A second machine you own | SFTP, or REST for append-only |
| No second site | Object storage |
| Anything you care about | One of the above, **plus** a second repository elsewhere |

The last row is not a fourth backend; it
is the point. Backends differ in
convenience, but copies in unlike places
are what make damage — a dead disk, a
deleted account, a flooded house — a bad
day instead of the end of the archive.

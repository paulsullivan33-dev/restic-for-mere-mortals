# The Moving Parts

Restic has few moving parts, but the ones
it has are worth knowing by name, because
every command in this guide — and every
error message — talks about them.

## The repository

The store everything goes into. On disk it
is just a folder of files with a fixed
shape, which the lab created and listed
(transcript `t01`):

| Entry | Holds |
|---|---|
| `config` | The repository's identity: its ID and the chunker settings chosen at creation |
| `keys/` | Your password, in the form of an encrypted copy of the master key |
| `data/` | The payload: your file contents, chopped, encrypted, packed |
| `index/` | Maps saying which pack holds which chunk |
| `snapshots/` | One small file per snapshot |
| `locks/` | Notes saying "a restic process is working here" |

Nothing in that folder is meant to be
edited by hand. Treat the whole folder as
one object: copy it, move it, put it on
another disk — restic on the other end
will read it fine.

## Chunks, blobs, and packs

When restic backs up a file, it does not
store the file. It slides along the file
cutting it into **chunks** of varying size
(about a megabyte on average) at boundaries
the data itself suggests. Each chunk is
hashed; the hash is its name. Identical
content — in another file, in another
folder, in next month's snapshot — hashes
to the same name and is stored once. The
stored, encrypted chunk is a **blob**.
Blobs are bundled into larger files called
**packs** (a few megabytes each), because
disks and networks both prefer a few big
files to thousands of tiny ones.

This one mechanism explains most of
restic's behaviour: why a second backup of
a barely-changed tree is nearly free, why
`forget` alone does not shrink a
repository (the blobs may still be shared),
and why `prune` exists to sweep up blobs
no snapshot references any more.

## Snapshots and trees

A **snapshot** records: the time, the host,
the paths backed up, any tags, and a
pointer to a **tree** — the directory
listing, where each file entry points at
the list of chunk hashes that rebuild it.
Restore is tree-walking: follow the
pointers, fetch the chunks, decrypt,
reassemble. Chapter 6 shows two snapshots
whose trees mostly point at the same
chunks.

## Keys: the password is not the key

Your password never encrypts your data
directly. At `init`, restic generates a
random **master key**, encrypts your data
with it, and stores a copy of that master
key encrypted *with your password* in
`keys/`. Two consequences worth knowing:

- Changing the password (`restic key
  passwd`) is fast and harmless: it
  re-wraps the same master key. Your data
  is not re-encrypted.
- You can have several passwords (`restic
  key add`) — several wrapped copies of
  one master key — which is how a team
  shares a repository without sharing one
  password. The lab listed its single key
  in transcript `t10`.

And the hard edge: **no password that
opens any key file means no data.** There
is no recovery path, by design.

## Backends

The repository folder has to live
somewhere, and a **backend** is restic's
way of reaching it: a local path, SFTP
over SSH, an HTTP **REST server** (a small
companion program, `rest-server`), or
object storage such as S3 or Backblaze B2.
Same repository format everywhere; chapter
11 covers the choices. The lab used the
local backend only; the others are
labelled documented-only where they
appear.

## The cache and locks

Two parts you will meet in error messages.
The **cache** is a local scratch copy of
indexes, kept so commands do not re-read
the whole repository every time; it can
always be deleted and rebuilt. **Locks**
stop two restic processes from writing to
one repository at once. A process that
dies leaves its lock behind, and chapter
15 covers the stale-lock conversation you
will eventually have with it.

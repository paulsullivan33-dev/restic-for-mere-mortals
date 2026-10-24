# Glossary

**Backend** — how restic reaches the
repository's storage: local path, SFTP,
REST server, or object storage.
Chapter 11.

**Blob** — one stored, encrypted chunk
inside a pack. Chapter 2.

**Cache** — restic's local scratch copy of
repository indexes, for speed. Always
safe to delete; it rebuilds.

**Check** — `restic check`: verifies
repository structure; with `--read-data`,
decrypts and hash-verifies the data
itself. Chapter 10.

**Chunk** — a piece of a file, cut at a
content-chosen boundary, named by its
hash. Identical chunks are stored once.
Chapter 2.

**Deduplication** — storing each distinct
chunk once, however many files or
snapshots point at it. Chapter 6.

**Forget** — removing snapshots by a
retention policy. Frees nothing by itself;
see prune. Chapter 9.

**Key** — a wrapped copy of the master
key, opened by one password. A repository
can hold several. Chapter 2.

**Lock** — a marker that a restic process
is working in a repository; blocks other
writers. Stale locks are removed with
`restic unlock`. Chapter 15.

**Master key** — the random key that
actually encrypts the data, generated at
`init` and never typed by anyone.
Chapter 2.

**Pack** — the file on disk that bundles
many blobs together; the unit prune
rewrites. Chapter 2.

**Parent snapshot** — the previous
snapshot of the same paths on the same
host, used to recognise unchanged files
without re-reading them. Chapter 5.

**Prune** — sweeping blobs no snapshot
references and repacking packs without
them. Chapter 9.

**Repository** — the store restic manages:
config, keys, data, index, snapshots,
locks. One folder, never edited by hand.
Chapter 4.

**Rest-server** — the companion program
that serves repositories over HTTP,
optionally append-only. Chapter 11.

**Snapshot** — one complete, browsable
picture of the backed-up paths at a
moment, physically sharing chunks with
its neighbours. Chapters 1 and 6.

**Tag** — a free-text label on a snapshot,
used by filters and retention policies.
Chapter 5.

**Tree** — a snapshot's directory listing,
where each entry points at the chunks
that rebuild a file. Chapter 2.

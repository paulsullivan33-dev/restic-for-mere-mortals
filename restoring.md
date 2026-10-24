# Restoring

Restoring is the point of the entire
exercise, and the lab rehearsed it the way
chapter 1 insists on: restore, then verify
the result independently, byte for byte
(transcript `t05`).

## The basic shape

```bash
restic restore latest --target /path/to/restore-into
```

Restic rebuilds the snapshot's tree under
the target, recreating the original path
structure inside it — restoring a backup of
`/home/you/field-notes` into `/tmp/check`
produces `/tmp/check/home/you/field-notes`.
That nesting surprises everyone once; it
is also what makes test restores safe,
since nothing lands on top of the live
files by accident.

Restore one snapshot, not the newest, by
naming its ID instead of `latest`. Restore
part of one with a path after the ID, or
`--include` patterns when the part is
scattered:

```bash
restic restore 997db8dc --target /tmp/check \
  --include '*garden-diary*'
```

## The verification habit

"Restic exited happily" is not
verification. Two checks, both used in
the lab, in increasing order of strength:

1. **`diff -r`** the restored tree against
   the original (when the original still
   exists): silence means the trees are
   identical. The lab's comparison exited
   0 — no differences.
2. **Checksums.** Before the lab's first
   backup, it recorded SHA-256 sums of the
   sample files. After restoring, it
   recomputed them inside the restored
   tree: every sum matched the original
   for the files that existed then, and
   the two copies of the photograph
   matched each other. Checksums you take
   *before* a loss and compare *after* a
   restore are the only proof that
   survives the original being gone —
   which is exactly the case a real
   restore usually is.

Do the rehearsal while the stakes are a
sample folder. The day the rehearsals are
for is not the day to learn the target
path behaviour.

## The lab's wrinkle, stated plainly

The lab's restore printed a run of
"ignoring error ... lchown ... operation
not permitted" lines and exited 1, while
restoring every file's *contents*
perfectly. The sandbox the lab ran in
does not permit changing file ownership,
so restic restored the data and reported —
honestly and individually — each ownership
it could not set. On an ordinary machine,
restoring as the user who owns the target
folder produces no such errors; restoring
as a different user than the files' owner
produces the cousins of these. Either way,
read restore output to the end: exit 1
with verified contents (the lab's case) is
a different event from exit 1 with missing
files, and only the verification step
tells you which one you had.

## Two neighbours of restore

- **`restic mount`** presents a repository
  as a read-only filesystem you can browse
  with ordinary tools. Delightful on a
  Linux desktop, it needs FUSE and is
  documented-only in this guide — the lab
  did not run it.
- **Restoring somewhere the original
  machine isn't** is just restore with a
  repository and a password; nothing in
  the format ties a repository to the
  machine that made it. That portability
  is worth testing before you rely on it,
  and the rehearsal above is the test.

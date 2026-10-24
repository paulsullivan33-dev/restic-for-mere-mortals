# Forgetting and Pruning

Snapshots accumulate at the rate you take
them. Left alone, a nightly backup becomes
a thousand snapshots — browsable and
harmless, but history you mostly do not
need at daily resolution forever.
**Retention** is the policy that thins
them: keep every snapshot for a while,
then one a week, then one a month.
Restic splits it into two commands,
deliberately.

## Step one: forget

```bash
restic forget --keep-last 1 --dry-run
```

`forget` removes **snapshot pointers**
according to a policy, and nothing else.
The `--dry-run` form — which the lab ran
first, and you always should — prints the
policy applied: which snapshots it would
keep and *why* ("last snapshot"), which it
would remove. The policy vocabulary:

| Flag | Meaning |
|---|---|
| `--keep-last N` | The N newest snapshots |
| `--keep-hourly / --keep-daily / --keep-weekly / --keep-monthly / --keep-yearly N` | The newest snapshot in each of the last N hours / days / weeks / months / years |
| `--keep-within 30d` (and `-daily`, `-weekly`...) | Everything younger than a duration |
| `--keep-tag TAG` | Never forget snapshots carrying this tag |

Policies apply per group — same host,
paths, and tags — so a policy written for
your nightly job does not thin your
manual snapshots unless you group them
together on purpose (`--group-by`). The
lab's run (transcript `t06`) kept the
newer of its two snapshots and forgot the
first:

```
remove 1 snapshots:
c81c812b  2026-10-24 04:07:52  ...  12.000 MiB
```

## Step two: prune

After the forget, the repository on disk
was the same size to within a few
kilobytes. That is not a bug; it is the
design of chapter 2 showing through. The
forgotten snapshot's chunks are mostly
**still referenced** by the surviving one,
and even the unreferenced ones sit in
packs until swept:

```bash
restic prune
```

`prune` works out which blobs no remaining
snapshot references, repacks the packs to
keep only those, and rebuilds the index.
The lab's prune removed **9 blobs, 2.978
KiB** — the pre-edit version of one small
document and its trees, nearly all the
first snapshot ever uniquely owned. The
two lessons generalise:

- **Forgetting a snapshot frees roughly
  what that snapshot uniquely added** —
  chapter 6's arithmetic, run in reverse.
  Forgetting early snapshots of a stable
  tree frees little; that is a sign
  deduplication worked, not that prune
  failed.
- **Prune is the expensive step.** It
  reads and rewrites packs, so on a large
  or remote repository it takes real
  time and traffic. Schedules usually
  forget nightly and prune weekly;
  `restic forget --prune` chains them
  when you would rather not think about
  it.

## What forgetting cannot do

It cannot be undone. There is no recycle
bin for snapshots: a forgotten snapshot
whose chunks a prune has swept is gone
with the completeness the encryption
promised. The defences are procedural —
always `--dry-run` first and read the
keep list, keep at least one policy leg
you cannot fat-finger (`--keep-tag` on
milestone snapshots), and remember that
retention is about history *resolution*,
not about making backups small. The backup
was already small. That was the problem
deduplication solved in chapter 6; this
chapter is about not keeping a thousand
daily photographs of a tree that changes
twice a year.

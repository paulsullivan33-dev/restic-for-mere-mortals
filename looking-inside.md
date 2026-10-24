# Looking Inside

A repository you cannot inspect is a black
box you are trusting. These are the
inspection commands, all run in the lab
against the two-snapshot repository of
chapter 6 (transcript `t04`).

## The list of snapshots

```bash
restic snapshots
```

```
ID        Time                 Host   Tags   Paths        Size
c81c812b  2026-10-24 04:07:52         ...    field-notes  12.000 MiB
997db8dc  2026-10-24 04:07:58         ...    field-notes  20.000 MiB
```

Every command that takes a snapshot
accepts the short ID, a full ID, or the
word **`latest`** — the newest snapshot
matching whatever other filters you gave
(host, path, tags). `latest` is convenient
in conversation and dangerous in scripts
you wrote months ago; chapter 12's recipes
still use it, with their filters written
tightly enough to deserve it.

Filters worth knowing: `--host`,
`--path`, `--tag` narrow the list (and
what `latest` means) to the snapshots you
actually run a schedule for.

## Walking a snapshot

```bash
restic ls latest
restic ls latest /path/inside/the/snapshot
```

`ls` prints the snapshot's tree: full
original paths, files only as names — the
contents stay in the repository until you
restore or `dump` them:

```bash
restic dump latest /path/to/one/file
```

prints a single file to standard output.
For finding rather than browsing:

```bash
restic find shed-key.txt
```

answers with every snapshot containing a
matching name and the path inside it —
the command you want at the moment someone
says "I deleted it on Tuesday, I think".

## Comparing two snapshots

```bash
restic diff <older-id> <newer-id>
```

`M` for modified, `+` added, `-` removed,
for files and directories, ending with the
blob arithmetic of chapter 6: how much
data the newer snapshot actually added.
Diff is also the cheapest integrity habit
available — run it between last night's
snapshot and tonight's, and a backup that
suddenly "changed" 40,000 files you never
touch is a story you hear from restic
first.

## How big, in which sense

```bash
restic stats            # restore-size: snapshots at face value
restic stats --mode raw-data
restic stats latest     # one snapshot, either mode
```

Chapter 6 explained the two senses:
restore-size for planning a restore,
raw-data for planning a disk. A third
mode, `files-by-contents`, counts unique
file contents — the number that tells you
how much of your archive is the same
photograph kept in five folders.

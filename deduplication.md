# Snapshots and Deduplication

This chapter is the proof chapter. Every
number below was measured in the lab on
restic 0.18.1; the transcripts are
`t02`, `t03`, and `t04` if you want the
raw output. The data is invented and
small — a `field-notes` folder of texts, a
CSV, and two binary "photographs" — but the
behaviour scales exactly as shown, because
it follows from the chunking in chapter 2
rather than from the data's size.

## The experiment

1. Back up 12 MiB of files (snapshot 1).
2. Change three things: copy an 8 MiB
   photograph under a second name
   (8 MiB of "new" data that is not new at
   all), append two lines to a document,
   and add one small new file.
3. Back up again (snapshot 2). The folder
   is now 20 MiB. Measure the repository
   before and after.

## The result

| | Snapshot 1 | After snapshot 2 |
|---|---|---|
| Data on disk | 12 MiB | 20 MiB |
| Repository size | 12,590,776 bytes | 12,595,923 bytes |
| What backup 2 added | — | **7.089 KiB** |

Read that middle row again. Eight mebibytes
of duplicated photograph, plus an edited
document, plus a new file, grew the
repository by **5,147 bytes**. Restic
reported it itself — "Added to the
repository: 7.089 KiB" — and the disk
agreed. Snapshot 2 presents as a complete
20 MiB picture of the folder (`restic
snapshots` lists it at 20.000 MiB), while
physically sharing nearly every chunk with
snapshot 1.

Why each change cost what it cost:

- **The copied photograph: ~0.** Its
  chunks already existed under the first
  name. A snapshot is pointers; a second
  pointer is nearly free. This is
  deduplication across files.
- **The appended document: one or two
  chunks.** Chunk boundaries follow the
  content, so an edit near the end leaves
  the earlier chunks untouched; only the
  changed region is stored afresh. This is
  deduplication across versions, and it is
  why a month of nightly snapshots of a
  slowly-growing document costs little
  more than the document.
- **The small new file: itself.** New
  content is new content; no mechanism
  makes a first copy cheap, only later
  ones.

## What deduplication is not

- **Not compression.** Compression shrinks
  data by finding patterns *inside* it;
  it barely touched the lab's random binary
  photographs (the stats in `t03` show a
  ratio of 1.00x — incompressible data
  stays its own size). Ordinary text and
  documents compress better. The two
  mechanisms are separate and both apply.
- **Not a promise about your data.** A
  folder of already-compressed video, or
  files that change completely every day,
  deduplicates poorly. "Depends on your
  setup" is the honest generalisation; the
  lab's ratio is what *this* data did.
- **Not shared between repositories.**
  Two repositories each store their own
  chunks. (Snapshots can be moved between
  repositories with `restic copy`, which
  is documented-only here.)

## Seeing it for yourself

`restic diff` between the two snapshots
(`t04`) states the change in the same
currency: 2 files new, 1 changed,
**Added: 7.089 KiB**, and 2 new data blobs
against 9 new tree blobs — mostly new
pointers, almost no new payload. And
`restic stats` draws the line between
appearances and storage in its two modes:
restore-size counts every snapshot as if
whole (32 MiB across the lab's snapshots
at one point), raw-data counts what is
physically there (12 MiB). When you are
deciding whether the repository still fits
its disk, raw-data is the number; when you
are deciding what a restore needs,
restore-size is.

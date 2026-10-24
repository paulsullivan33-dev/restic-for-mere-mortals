# Writing Criteria

Every guide in this repo is written to the same
standard. If you're adding or editing a guide —
human or AI — hold it to these.

1. **Plain words, real ideas.** Simple language,
   never dumbed-down concepts. Explain jargon on
   first use; collect terms in the glossary.
2. **No hype.** No marketing adjectives, no
   "revolutionary," no promises about what
   something will do for the reader.
3. **Honest about limits.** Say what the thing
   *can't* do. State uncertainty instead of
   smoothing it over. Validation notes include
   what remains unverified.
4. **No invented numbers.** Benchmarks, defaults,
   and specs are either measured or qualified with
   "depends on your setup." If it wasn't tested,
   say so.
5. **Checkable.** Commands are meant to be run,
   with "Check:" blocks showing what success looks
   like. Sources are linked, not asserted.
6. **Respect the reader's setup.** Call out
   Windows/Mac/Linux differences. Don't assume a
   GPU, a budget, or prior experience.
7. **Safety isn't skipped.** Real risks get
   stated plainly, not buried.
8. **Scoped.** Each guide says what it covers and
   points elsewhere for the rest. No guide
   pretends to be the whole subject.
9. **Structure over prose.** Tables, before/after
   examples, symptom → fix. Scannable beats essay.

## Verification notes for this guide

Built and verified 2026-10-24 against
**restic 0.18.1** (the project's current
release on build day), the official Linux
amd64 binary, on Ubuntu 24.04. Repository
format version 2, as created by default.

**Ran for real** (transcripts in
`restic-lab/transcripts/`):

- t00 — `restic version`: 0.18.1.
- t01 — `restic init` on a local
  repository; the created folder matches
  chapter 2's table; `restic cat config`
  shows version 2 and the repository ID.
- t02 — first backup of the invented
  12 MiB `field-notes` tree: 5 files,
  "Added to the repository: 12.006 MiB",
  snapshot `c81c812b`; repository measured
  at 12,590,776 bytes.
- t03 — the deduplication experiment:
  an 8 MiB photograph copied under a
  second name, two lines appended to a
  document, one small file added; the
  tree is now 20 MiB and the second
  backup reported "Added to the
  repository: 7.089 KiB"; the repository
  grew by 5,147 bytes to 12,595,923.
  `restic stats` in both modes recorded
  (raw-data ratio 1.00x: the random binary
  fixtures do not compress, and the
  chapters say so).
- t04 — `restic ls latest`, `restic diff`
  between the snapshots (2 new, 1 changed,
  Added 7.089 KiB), `restic find` locating
  the planted file.
- t05 — `restic restore latest` into a
  scratch target, verified two ways:
  `diff -r` against the original tree
  exited 0, and SHA-256 sums recorded
  before the first backup matched the
  restored files (the two photograph
  copies also match each other).
- t06 — `restic forget --keep-last 1`,
  rehearsed with `--dry-run` first, then
  `restic prune`: 9 blobs / 2.978 KiB
  removed; repository 12,591,525 bytes.
  The smallness of the freeing is itself
  reported and explained in chapter 9.
- t07 — `restic check` and
  `restic check --read-data`: both "no
  errors were found".
- t08 — a wrong password ends the command
  with "Fatal: wrong password or no key
  found" (exit 12).
- t09 — a tagged backup (`--tag fieldnotes
  --tag weekly`) with an exclude file: the
  excluded scratch file was searched for
  in the snapshot and is absent (count 0).
- t10 — `restic key list`: the lab's
  single key.

**Errors and wrinkles met for real,**
written up in chapters 8 and 15: the
restore exited 1 in the lab sandbox with
one `lchown ... operation not permitted`
line per file, because the sandbox does
not permit assigning file ownership;
every file's contents were nevertheless
restored and verified. The chapters state
this as the sandbox's property, not as
normal behaviour on an ordinary machine.

**Documented only, and labelled as such
in the chapters:** the SFTP, REST-server
(including append-only mode), and
object-storage backends (S3, B2, Azure,
GCS) — the lab ran the local backend
only; `restic mount`; `restic copy`
between repositories; `restic migrate`;
`restic self-update`; and the `repair`
commands (the lab damaged nothing to
repair). The lab's declared deviation:
repository and data lived on the same
machine and disk, which chapter 4
explicitly warns real setups against.

**Fixtures:** the `field-notes` folder —
a garden diary, a shopping list, a note
about a shed key, a bed-plan CSV, and two
random-binary "photographs" — is invented
and located in a private working folder,
not modelled on any real person's files.
The lab password is invented, was supplied
by environment variable, and appears in no
transcript.

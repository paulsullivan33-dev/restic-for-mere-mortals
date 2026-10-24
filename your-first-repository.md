# Your First Repository

A repository is created once, with
`restic init`, and two of the choices made
in that minute are permanent: where it
lives, and its password. This chapter goes
slowly on both.

## Where it should live

The rules are about failure, not
convenience:

- **Not only on the same disk as the
  data.** A repository beside the files it
  backs up dies in the same house fire,
  flood, theft, or disk failure. A second
  disk in the same machine is better; a
  disk in another machine, or storage
  somewhere else entirely, is the point of
  the exercise. Chapter 11 lists the ways
  of reaching those places.
- **Somewhere you can also *check*.**
  Whatever holds the repository must let
  you run restic against it regularly —
  a backup nobody can verify is a rumour.
- **Big enough for history, not just for
  today.** Deduplication makes history
  cheap, but it is not free. Chapter 6's
  numbers give a feel for the real ratio
  on real-ish data.

The lab's repository lives at
`~/workspace/restic-lab/repo`, beside its
data, because a lab is allowed to be
wrong in ways a real setup is not. Do what
the guide says, not what the lab did.

## Telling restic where, and the password

Two environment variables save repeating
yourself in every command:

```bash
export RESTIC_REPOSITORY=/path/to/repo
export RESTIC_PASSWORD='your-repository-password'
```

`RESTIC_PASSWORD` in your shell history
and in a script is a password written
down in two more places. Restic offers
three gradations, and the guide recommends
them in this order for anything real:

| Method | How | Trade-off |
|---|---|---|
| Password command | `RESTIC_PASSWORD_COMMAND` names a program that prints the password | The password lives in a password manager or keyring, where it belongs; one more moving part |
| Password file | `RESTIC_PASSWORD_FILE` points at a file holding only the password | Simple; the file is a secret, protect it like one (owner-only permissions) |
| Environment variable | `RESTIC_PASSWORD` set in the shell | Fine for learning and one-off runs; leaks into scripts and history if you are careless |

For interactive use, typing the password
at restic's prompt each time is also fine
— restic asks when none of the three is
set. The lab used the environment variable
because its password is invented and
worthless (`lab-only-password-...`), and
the transcripts never print it.

## Creating it

```bash
restic init
```

Check: restic answers that it created a
repository, and then says the quiet part
out loud (transcript `t01`):

```
Please note that knowledge of your password is required to access
the repository. Losing your password means that your data is
irrecoverably lost.
```

That is not legal boilerplate; it is a
literal description of the cryptography in
chapter 2. Write the password down
somewhere that survives the machine —
a password manager, or paper in a drawer —
before you back up anything you care
about. Then look at what was made:

```bash
ls -la "$RESTIC_REPOSITORY"
restic cat config
```

The folder matches chapter 2's table, and
`cat config` shows the repository's ID.
That ID is worth pasting into your notes:
it is how you confirm, years later on a
different machine, that the repository you
found is the repository you meant.

## The first decision you can revisit

Repository **format version 2** — the
current default, and what the lab's config
shows — supports compression of stored
data. It has been the default since restic
0.16 and needs nothing from you. Older
repositories keep working; `restic migrate`
is how formats are upgraded, and it is
documented-only in this guide because the
lab created a current repository and had
nothing to migrate.

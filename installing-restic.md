# Installing Restic

Restic is one static binary. There is no
installer wizard, no service, and nothing
to configure after placing the file
somewhere on your path. This is the
easiest install in the whole series, and
it is worth doing carefully anyway, because
*which* restic you install decides how old
it is.

## The choices, honestly

- **Your distribution's package**
  (`apt install restic`, `dnf install
  restic`, `brew install restic`, or
  `winget install restic.restic` on
  Windows). Convenient, signed, updated
  with the system — and often several
  releases behind the project. For a tool
  whose repository format is stable, an
  older binary still reads and writes the
  same repositories; you mainly miss newer
  features and fixes.
- **The official binary** from the
  project's GitHub releases — a single
  compressed file per platform. This is
  what the lab used: restic **0.18.1**,
  the current release on build day,
  downloaded, decompressed, made
  executable, and run in place.
- **Built into another machine**: most
  NAS and backup appliances that speak
  restic bundle their own copy; check its
  version before trusting it with a
  repository the newer binary created.

Check what you ended up with:

```bash
restic version
```

Check: it prints a version line, like the
lab's (transcript `t00`):

```
restic 0.18.1 compiled with go1.25.1 on linux/amd64
```

## Self-update, and its limit

Binaries obtained from the project can
update themselves:

```bash
restic self-update
```

Package-manager installs generally cannot
(the files are owned by the package
system), and restic will tell you so
rather than failing quietly. Either way,
updating is a convenience, not a chore to
schedule: repositories are compatible
across a wide range of versions, and this
guide's commands are stable across them.

## Windows and macOS notes

The same binary exists for both, and every
command in this guide works there with two
adjustments: paths use the local spelling
(`C:\Users\you\Documents` rather than
`/home/you/documents`), and giving the
password through an environment variable
uses the local shell's syntax
(`$env:RESTIC_PASSWORD` in PowerShell,
`set RESTIC_PASSWORD=` in the old Command
Prompt). Scheduling differs — Task
Scheduler instead of cron — everything
else in the guide is identical.

## What the lab did

Downloaded the official Linux amd64
binary of 0.18.1, verified it ran, and put
it on the path of an ordinary working
folder. No repository, no data, and no
other machine was involved yet. Chapter 4
creates the first repository — slowly,
because the decisions in it (where it
lives, what its password is, how the
password reaches restic) are the ones a
real setup lives with for years.

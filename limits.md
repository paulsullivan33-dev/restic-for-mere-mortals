# Limits

Stated plainly, per this series' habit:

- **The password is absolute.** Lose every
  password that opens a key and the
  repository is ciphertext forever. No
  check, repair, or support channel
  changes this; chapter 10.
- **File-level, not image-level.** Restic
  restores files and folders. Rebuilding a
  dead machine means reinstalling its
  system and restoring onto it — workable,
  rehearsed in chapter 8's terms, but not
  a one-command resurrection.
- **Live databases are not backed up
  safely by copying their files.** The
  files may be mid-write and mutually
  inconsistent. Dump, then back up the
  dump (chapter 12). The same caution
  applies, more mildly, to any file being
  actively written during a backup: restic
  reads what it finds and reports what it
  could not read.
- **No scheduler, no daemon.** Restic runs
  when something runs it. A laptop that is
  asleep at 2 a.m. makes no 2 a.m. backup;
  pick times and tools (cron, systemd
  timers with wake options, Task
  Scheduler) that match how the machine
  actually lives.
- **Deduplication has a memory of its
  own.** Finding chunks in a very large
  repository takes RAM, roughly in
  proportion to the repository's size;
  small machines backing up very large
  trees can feel it. It is a sizing
  consideration, not a wall, and it is
  stated here rather than discovered at
  3 a.m.
- **Prune is not free.** It re-reads and
  rewrites data, which on remote and
  metered backends costs time and money.
  Retention policies are cheap; sweeping
  is not. Chapter 9.
- **Metadata has edges.** Ownership and
  permissions restore best as the same
  user on the same kind of system;
  Windows and Unix do not mean the same
  things by them, and the lab's sandbox
  produced a restore full of ownership
  warnings with perfect contents
  (chapter 8). Extended attributes and
  exotic file types vary by platform and
  are the first thing to test if they
  matter to you.
- **One writer at a time, per
  repository.** Locks keep concurrent
  writers out by design; two machines
  backing up to one repository take turns
  or fail on the lock. Schedules should
  stagger, or repositories should differ.

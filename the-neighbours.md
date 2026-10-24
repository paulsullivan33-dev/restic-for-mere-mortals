# The Neighbours

Restic is not the only respectable answer,
and several neighbours do something it
does not. Honest trades, one line each on
what would make you choose them instead.

| Tool | Shape | Choose it if... |
|---|---|---|
| **BorgBackup** | Deduplicating, encrypted, SSH-first archiver | You live on Linux/macOS, back up to your own servers, and want the older, battle-tested tool; restic's edge is its wider backend and Windows support |
| **Duplicati** | Backup with a web interface, to many clouds | You want to click rather than script, and accept a heavier, slower-moving project |
| **rsync + hard links** (`rsnapshot`, hand-rolled) | Snapshot trees of real files | You want backups you can browse with no special tool at all — and accept no encryption and hard-link fragility |
| **rclone** | Sync and copy to cloud storage | Moving files is the job; add restic when the job becomes *history with encryption* (rclone can also serve as a restic backend) |
| **Syncthing / cloud drives** | Synchronisation | Both places should simply be the same — knowing deletions sync too (chapter 1's distinction) |
| **Timeshift / system snapshots** | Whole-system restore points | The thing you are protecting is the operating system itself, not your files |
| **Vendor cloud backup** (Backblaze Personal, iCloud, OneDrive) | Managed, automatic | You value never thinking about it, at subscription price and with the provider holding readable copies (or the keys) |

Two confusions worth dissolving. First,
**Borg versus restic** is the real contest
in this space, and it is close: both
chunk, deduplicate, and encrypt. Borg's
repository wants its own server component
for best results and historically stayed
Unix-only; restic stores to more places
with less ceremony and runs natively on
Windows. People with strong feelings
either way are usually describing which
one they learned first. Second,
**a sync tool plus a recycle bin is not a
backup strategy** — it has no answer to
"the good version was overwritten in
March and noticed in June", which is the
question snapshots exist to answer.

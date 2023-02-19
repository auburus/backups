help:
  @just -l

init:
  borg init --encryption=repokey ./borg-repo

# Create backup file
backup-create:
  borg create \
    --progress \
    --stats \
    --exclude-from ./EXCLUDEFILE \
    ./borg-repo::{now} ~/files

# Remove old backups
backup-prune:
  borg prune \
    --keep-daily 1 \
    --keep-weekly 2 \
    --keep-monthly 4 \
    --keep-yearly 8 \
    ./borg-repo

  borg compact ./borg-repo

# List backups
list:
  borg list ./borg-repo

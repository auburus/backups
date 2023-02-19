set dotenv-load

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


offsite-create:
  #!/bin/bash
  cd terraform
  terraform init
  terraform apply


# List local backups
list:
  borg list ./borg-repo

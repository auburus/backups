set dotenv-load

help:
  @just -l

init:
  borg init --encryption=repokey ./borg-repo

# Combined backup script
backup:
  @just backup-create
  @just backup-prune
  @just backup-offsite

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

backup-offsite:
  #!/bin/bash
  set -euo pipefail
  export B2_APPLICATION_KEY=$(terraform -chdir=terraform output -json | jq -r '.b2_backups_api_keys.value.application_key')
  export B2_APPLICATION_KEY_ID=$(terraform -chdir=terraform output -json | jq -r '.b2_backups_api_keys.value.application_key_id')

  set -x
  pipx run b2 sync ./borg-repo "b2://$B2_BUCKET_NAME/borg-repo"

offsite-create:
  #!/bin/bash
  cd terraform
  terraform init
  terraform apply


# List local backups
list:
  borg list ./borg-repo

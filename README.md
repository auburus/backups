Backup automation
=================

Repository to automate my backups


# Usage
This repo uses [just](https://github.com/casey/just/) as a nicer alternative to
Make.

Other requirements:
- [Borg](https://www.borgbackup.org/): Backup software (really impressed by it).
- [Backblaze](https://www.backblaze.com/): An account to store offsite backups.
- [Terraform](https://www.terraform.io/): Create backblaze bucket.
- [Pipx](https://pypa.github.io/pipx/) / [b2](https://www.backblaze.com/b2/docs/python.html):
  Python API for interacting with backblaze (TODO: Evaluate `rclone`, I've heard
  good things).


First step is to set up the secrets in `.env`. Use `.env.example` as a source.

Then, `just offsite-create` will create a bucket in backblaze to store your backups,
with a random name.
And `just backup` will create the backup, prune old backups and push it to backblaze.

It doesn't get much simpler than that.

## Issues
I still need to finish this steps before calling this project done:
- Automated tests: A backup is not a backup until is tested.
- Running automatically: Currently thinking some systemd cron/startup job.

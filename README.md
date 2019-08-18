# cloudmount

MergerFS + RClone + Service Account Uploader

Made for my own use, but you can change it for your needs by changing the appropiate env vars.

## Required Config

This requires a valid working rclone config - `/config/rclone.conf`

It also requires you to create a file, located at `/config/sa_list`. This will be a list of `[sectionname]`'s that you defined for the service account keys in the `rclone.conf` file.

**Example:** rclone.conf:

```rclone.conf
[tdrive]
client_id = xxx.apps.googleusercontent.com
client_secret = xxx
type = drive
token = {"access_token":"xxx","token_type":"Bearer","refresh_token":"xxx","expiry":"xxx"}
team_drive = xxx

[GDSA01]
type = drive
scope = drive
service_account_file = /config/gsa/GDSA01 # must be inside /config (do not change the /config root path)
team_drive = xxx

[GDSA02]
type = drive
scope = drive
service_account_file = /config/gsa/GDSA02
team_drive = xxx

```

**Example:** sa_list:

```txt
GDSA01
GDSA02
```

## Upload

### Change upload directories

By default the root of the local drive is moved. You can change the upload directory by setting the env var `RCLONE_UPLOAD_LOCAL_PATH`. The value should be a path relative to the root of the local volume.

By default files are uploaded to the root of the remote drive. You can change this by setting  the env var `RCLONE_UPLOAD_REMOTE_PATH`. The path is relative to the root of the remote volume.

### Copy instead of move

By default rclone will move the files from your local to the remote.
You can copy files instead by changing the env var `RCLONE_UPLOAD_CMD=copy`

### Exclude Directories from uploading

You can ignore any directory from uploading with an `.ignore` file.
`touch .ignore` inside a directory you don't want to upload.

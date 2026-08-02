# bitwarden-truenas-backup
An automated system to easily backup a selfhosted instance of Bitwarden to a TrueNAS NFS share enabling and disabling said share.
The current version is for version 25.10.5 of TrueNAS

# Installation:
It is quite simple to install the system. First you must clone the repo and create a python venv.


```bash
git clone https://github.com/generalmat82/bitwarden-truenas-backup.git
cd bitwarden-truenas-backup
python3 -m venv .venv
```

Make sure to add to /etc/fstab a mount that does not automount to your share.
```
<addr>:/</share/path>    <share/mount> nfs     rw,relatime,user,noauto 0       0
```

After, you need to install the required py package, the system only requires 2 py package: api_client and python-dotenv
The package depends on your trueNAS version so you should run the following, make sure to replace the \<tag\> with your version (e.g `TS-25.04.2.6`)
```bash
./.venv/bin/pip install git+https://github.com/truenas/api_client.git@<tag>
./.venv/bin/pip install python-dotenv
```

# Configuration:

There is an example .env file named `.env.example` copy it into `.env`
You can now fill up the required information, here is a filled example:
```env
TRUENAS_URI="wss://truenas.domain/api/current"
API_KEY="3-dfjkglhfdjklghkjlfghkjtjyHTdfgfTYHjbnkltfhyioklfgjkltd59046okd04"
LOCAL_BACKUP_PATH="/opt/backups"
REMOTE_BACKUP_PATH="/media/backup"
TRUENAS_SHARE_PATH="/mnt/my_pool/backup"
BITWARDEN_PATH="/opt/bitwarden/bwdata"
```
After which, you may want to test the configuration: `./backup.sh`
You can then use the script how ever you want. Reccommentation is to put it on a CronTab.
# Explanation of the .env parameters
Here is an explanation of each parameters

## TRUENAS_URI
This would be the endpoint of the TrueNAS machine.

## API_KEY
This is the API key for the TrueNAS API

## LOCAL_BACKUP_PATH
Location of the backup locally.

## REMOTE_BACKUP_PATH
Location of the mount set in `/etc/fstab`

## TRUENAS_SHARE_PATH
Full path of the TrueNAS share dataset.

## BITWARDEN_PATH
bwdata file path
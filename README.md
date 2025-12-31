# bitwarden-truenas-backup
An automated system to easily backup a selfhosted instance of Bitwarden to a TrueNAS scale NFS share enabling and disabling said share.

# Installation:
It is quite simple to install the system. First you must clone the repo and create a python venv.


```bash
git clone https://github.com/generalmat82/bitwarden-truenas-backup.git
cd bitwarden-truenas-backup
python3 -m venv ./
```

Make sure to add to /etc/fstab a mount that does not automount to your share.
```
<addr>:/</share/path>    <share/mount> nfs     rw,relatime,user,noauto 0       0
```

After, you need to install the required py package, the system only requires 1 py package: websocket

```bash
./bin/pip install websocket
```

# configuration:


Now create a new file named `.env` and add the following to the file:
```env
apikey="<insert key here>"
localBackupPath="<insert path here>"
remoteBackupPath="<insert path of mount>"
truenas_share_id="<insert share id>"
truenas_addr="<insert ip address>"
bitwarden_path="<path to bitwarden bwdata dir>"
```

## obtaining the share ID and api key:

In order to obtain the API key, go to your truenas dashboard and select your user then select "API Keys".

In the API Keys window, create an API key via the add button and name it then copy the key.

In the same tab select "API Docs" beside "Add", in this new tab select RESTful 2.0 in the top left. Then press the "authorize" button and enter your user's credentials and select "Authorize".

After, seacrch for "/sharing/nfs" and expend the "get" command by the same name.

Press "Try it out" followed by "Execute", in the response find the ID for the wanted share.

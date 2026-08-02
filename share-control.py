from truenas_api_client import Client
from dotenv import load_dotenv
import os
import sys

load_dotenv()


def strtobool(value: str) -> bool:
  value = value.lower()
  if value in ("y", "yes", "on", "1", "true", "t"):
    return True
  return False


with Client(uri=os.getenv("TRUENAS_URI")) as c:
    c.call("auth.login_with_api_key",os.getenv("API_KEY"))
    NFS_SHARES=list(c.call("sharing.nfs.query")) # type: ignore
    for share in list(NFS_SHARES):
        if share["path"] == os.getenv("TRUENAS_SHARE_PATH"):
            print(share)
            break
    c.call("sharing.nfs.update",share["id"],{"enabled":strtobool(sys.argv[1])})
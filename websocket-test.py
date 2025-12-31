from websocket import create_connection
import json, sys
from dotenv import load_dotenv
def strtobool(value: str) -> bool:
  value = value.lower()
  if value in ("y", "yes", "on", "1", "true", "t"):
    return True
  return False
load_dotenv()
attended=strtobool(sys.argv[2])

class socket:

    def __init__(self,url, debug=False):
        self.link = url
        self.state = "disconected"
        self.debug = debug

    def connect(self):
        if self.state == "disconected":
            self.ws = create_connection(self.link)
            if attended: print("connection created")
            message = {"version": "1", "msg": "connect", "support": ["1"]}
            if attended: print("sending connection request")
            self.ws.send(json.dumps(message))
            result = dict(json.loads(self.ws.recv()))
            if self.debug:
                print("connect result:")
                print(result)
            self.session = result["session"]
            self.state = "Connected, not logged in"
            if attended: print("connected")
        else: print("already logged in")

    def login(self):
        if self.state == "Connected, not logged in":
            message = {
                "id": self.session,
                "msg": "method",
                "method": "auth.login_with_api_key",
                "params": ["1-"+os.getenv('apikey')]
            }
            if attended: print("sending login request")
            self.ws.send(json.dumps(message))
            if attended: print("waiting answer")
            result = dict(json.loads(self.ws.recv()))
            if self.debug:
                print("login result:")
                print(result)
            if result['result']:
                print("logged in")
                self.state = "logged in"
        else: print("already logged in")

    def logout(self):
        if self.state == "logged in":
            message = {
                "id": self.session,
                "msg": "method",
                "method": "auth.logout"
            }
            if attended:print("sending log out message")
            self.ws.send(json.dumps(message))
            result = dict(json.loads(self.ws.recv()))
            if self.debug: print(result)
            self.ws.close()
            self.state = "disconected"
            print("logged out")
        else: "not logged in"

    def tx_rx(self,message:dict):
        message["id"] = self.session
        message["msg"] = "method"
        print(message)
        if attended: print("sending")
        self.ws.send(json.dumps(message))
        if self.debug: print("sent")
        if attended: print("waiting answer")
        result = dict(json.loads(self.ws.recv()))
        if attended: print("answer received")
        if self.debug: print(result)
        return result["result"]

if attended: print("generating socket")
ws = socket("ws://"+os.getenv('truenas_addr')+"/websocket")
if attended: print("generated, now connecting")
ws.connect()
if attended: print("conected, now loging in")
ws.login()
#message1 = {"method": "sharing.nfs.query"}
#result = ws.tx_rx(message1)
#print(result)

on_off=strtobool(sys.argv[1])


message = {
    "method": "sharing.nfs.update",
    "params": [os.gentenv('truenas_share_id'), {"enabled": on_off}]
}
if attended: print("sending share control command")
result = ws.tx_rx(message)
#print(result)
if attended: print("loging out")
ws.logout()

if attended:print("share controll script over")

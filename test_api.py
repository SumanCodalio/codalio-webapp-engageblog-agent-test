import urllib.request
import json
req = urllib.request.Request("http://127.0.0.1:6030/api/auth/login", data=json.dumps({"email":"administrator@example.com","password":"password"}).encode(), headers={"Content-Type":"application/json"})
res = urllib.request.urlopen(req)
token = json.loads(res.read().decode())["token"]
req2 = urllib.request.Request("http://127.0.0.1:6030/api/demo-org/posts", headers={"Authorization": "Bearer " + token, "Content-Type":"application/json"})
res2 = urllib.request.urlopen(req2)
print(res2.read().decode())

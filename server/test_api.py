import urllib.request
import json
req = urllib.request.Request("http://127.0.0.1:6030/api/auth/login", data=json.dumps({"email":"administrator@example.com","password":"password"}).encode(), headers={"Content-Type":"application/json"})
res = urllib.request.urlopen(req)
token = res.headers.get("Authorization") or res.headers.get("access-token") or ""
client = res.headers.get("client") or ""
uid = res.headers.get("uid") or ""

req2 = urllib.request.Request("http://127.0.0.1:6030/api/demo-org/posts", headers={"Authorization": token, "client": client, "uid": uid, "Content-Type":"application/json"})
res2 = urllib.request.urlopen(req2)
print(res2.read().decode())

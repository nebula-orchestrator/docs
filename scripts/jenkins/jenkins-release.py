#!/usr/bin/python2.7
# the following script allows jenkins to restart a nebula app thus loading a new version of it for deployment to use
# just have the script on the jenkins server\worker as well as ensuring it has requests python module installed after
# changing the 'authorization' to you  basic auth key & have
# your build have an "execute shall" run the following command:
# ./jenkins-release.py <nebula_app_name>
import requests, sys

app = sys.argv[1]

url = "http://<your_api_ip_or_fqdn>/api/apps/" + app + "/restart"

payload = ""
headers = {
    'authorization': "Basic <your_basic_auth_base64_user_pass>",
    'content-type': "application/json",
    'cache-control': "no-cache"
    }

response = requests.request("POST", url, data=payload, headers=headers)
print(response.text)

if response.status_code in range(200, 300):
    exit(0)
else:
    exit(2)

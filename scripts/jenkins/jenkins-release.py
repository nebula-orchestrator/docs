#!/usr/bin/python2.7
#
# requires requests module installed on your jenkins server
#
# the following script allows jenkins to restart a nebula app thus loading a new version of it for deployment to use
# just have the script on the jenkins server\worker as well as ensuring it has requests python module installed after
# changing the 'BASIC_AUTH_TOKEN' & 'NEBULA_API_HOST' to you  basic auth key & Nebula api FQDN then have your build have
# an "execute shall" run the following command:
# ./jenkins-release.py <nebula_app_name>
import requests, sys

# change this to your Nebula user:pass auth64 basic auth token
BASIC_AUTH_TOKEN = "<your_basic_auth_base64_user_pass>"
NEBULA_API_HOST = "<your_api_ip_or_fqdn>"

app = sys.argv[1]

url = "http://" + NEBULA_API_HOST + "/api/apps/" + app + "/restart"

payload = ""
headers = {
    'authorization': "Basic " + BASIC_AUTH_TOKEN,
    'content-type': "application/json",
    'cache-control': "no-cache"
    }

response = requests.request("POST", url, data=payload, headers=headers)
print(response.text)

if response.status_code in range(200, 300):
    exit(0)
else:
    exit(2)

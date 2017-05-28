# get api status
a simple webpage that can be used to monitor the API is working
### request
```
GET /api/status HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-token-here>
Content-Type: application/json
Cache-Control: no-cache
Postman-Token: c3c35e8d-e242-b7ac-4b76-d7879be2398a
```

### response example
success
```
200
{ "api_avilable": "True" }
```

# create app
create a new app inside the Nebula cluster
### request
```
POST /api/apps/test HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-token-here>
Content-Type: application/json
Cache-Control: no-cache
Postman-Token: 1c4b215b-7bb4-8045-4896-9c4d3ac3c2de
 
{
    "starting_ports": [80],
    "containers_per_cpu": 5,
    "env_vars": {"test": "test123"},
    "docker_image" : "registry.vidazoo.com:5000/nginx",
    "running": true,
    "network_mode": "bridge"
}
```

### response example
success
```
202
{
  "containers_per_cpu": 5,
  "docker_image": "registry.vidazoo.com:5000/nginx",
  "env_vars": {
    "test": "test123"
  },
  "running": true,
  "starting_ports": [
    80
  ]
}
```

missing paramters
```
400
{
 "missing_parameters": "True"
}
```

app already exists
```
403
 {
    "app_exists": "True"
}

```

# delete app
delete an app from the nebula cluster, be careful as the only way to restore a deleted app is manually creating it with the same veriables
### request
```
DELETE /api/apps/test HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-token-here>
Content-Type: application/json
Cache-Control: no-cache
Postman-Token: 40e88690-33da-de0a-2a1c-1b01459bab8e
```

### response example
success:
```
202
 {}
```

when trying to delete a non existing app:
```
403
{
    "app_exists": "False"
}
```

# list apps
list all apps managed in the current Nebula cluster
### request
```
GET /api/apps HTTP/1.1
Host: nebula-api-01.private02.aws.vidazoo.com
Authorization: Basic <your-token-here>
Content-Type: application/json
Cache-Control: no-cache
Postman-Token: 9ed33e7a-ade5-8512-2faf-e8697d855af8
```

### response example
```
200
 {
  "apps": [
    "test"
  ]
}
```

# get app config
get a specific Nebula app config 
### request
```
GET /api/apps/test HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-token-here>
Content-Type: application/json
Cache-Control: no-cache
Postman-Token: d67e1044-561e-cf39-a59a-93101102231e
```

### response example
```
200
{
  "containers_per_cpu": 8,
  "app_name": "test",
  "env_vars": {
    "test": "blabla123",
    "test3t2t32": "tesg4ehgee"
  },
  "running": true,
  "starting_ports": [
    80,
    443,
    5555
  ],
  "_id": {
    "$oid": "57ebd2ed28447e1e09e72d6a"
  },
  "docker_image": "registry.vidazoo.com:5000/httpd"
}
```

# stop app
stop a running Nebula app
### request
```
POST /api/apps/test/stop HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-token-here>
Content-Type: application/json
Cache-Control: no-cache
Postman-Token: 393100e2-fb29-3b02-fb66-b77388f810b1
```

### response example
```
202
{
  "containers_per_cpu": 8,
  "app_name": "test",
  "env_vars": {
    "test": "blabla123",
    "test3t2t32": "tesg4ehgee"
  },
  "running": false,
  "command": "stop",
  "starting_ports": [
    80,
    443,
    5555
  ],
  "_id": {
    "$oid": "57ebd2ed28447e1e09e72d6a"
  },
  "docker_image": "registry.vidazoo.com:5000/httpd"
} 
```

# start app
start a Nebula app
### request
```
POST /api/apps/test/start HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-token-here>
Content-Type: application/json
Cache-Control: no-cache
Postman-Token: 8be83768-3921-f4cd-a6cb-b4fcda6b7e32
```

### response example
```
202
 {
  "containers_per_cpu": 8,
  "app_name": "test",
  "env_vars": {
    "test": "blabla123",
    "test3t2t32": "tesg4ehgee"
  },
  "running": true,
  "command": "start",
  "starting_ports": [
    80,
    443,
    5555
  ],
  "_id": {
    "$oid": "57ebd2ed28447e1e09e72d6a"
  },
  "docker_image": "registry.vidazoo.com:5000/httpd"
}
```

# restart app
note that restarting an app also force pulling the latest version of the docker container so can be used as a form of deployment method assuming that the you overwritten the container tag in your docker registry with a newer version
### request
```
POST /api/apps/test/restart HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-token-here>
Content-Type: application/json
Cache-Control: no-cache
Postman-Token: fa2e1e6f-c0c9-0dc5-a323-00ed9503cf4e
```

### response example
```
202
{
  "containers_per_cpu": 8,
  "app_name": "test",
  "env_vars": {
    "test": "blabla123",
    "test3t2t32": "tesg4ehgee"
  },
  "running": true,
  "command": "restart",
  "starting_ports": [
    80,
    443,
    5555
  ],
  "_id": {
    "$oid": "57ebd2ed28447e1e09e72d6a"
  },
  "docker_image": "registry.vidazoo.com:5000/httpd"
}
```

# rolling restart app
not fully implemented yet - do not use!!!

note that restarting an app also force pulling the latest version of the docker container so can be used as a form of deployment method assuming that the you overwritten the container tag in your docker registry with a newer version
### request
```
POST /api/apps/test/roll HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-token-here>
Content-Type: application/json
Cache-Control: no-cache
Postman-Token: fa2e1e6f-c0c9-0dc5-a323-00ed9503cf4e
```

### response example
```
202
{
  "containers_per_cpu": 8,
  "app_name": "test",
  "env_vars": {
    "test": "blabla123",
    "test3t2t32": "tesg4ehgee"
  },
  "running": true,
  "command": "roll",
  "starting_ports": [
    80,
    443,
    5555
  ],
  "_id": {
    "$oid": "57ebd2ed28447e1e09e72d6a"
  },
  "docker_image": "registry.vidazoo.com:5000/httpd"
}
```

# update app
update a Nebula app config, currently all the permaters needs to be overwritten at once  (POST only), UPDATE support is on the todo list
### request
```
POST /api/apps/test/update HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-token-here>
Content-Type: application/json
Cache-Control: no-cache
Postman-Token: 9cd8b55e-2512-07fc-9cf1-15fc5c562635
 
{
    "starting_ports": [80, 443, 5555],
    "containers_per_cpu": 8,
    "env_vars": {"test": "blabla123", "test3t2t32": "tesg4ehgee"},
    "docker_image" : "registry.vidazoo.com:5000/httpd",
    "running": true,
    "network_mode": "bridge"
}
```

### response example
success:
```
202
 {
  "containers_per_cpu": 8,
  "app_name": "test",
  "env_vars": {
    "test": "blabla123",
    "test3t2t32": "tesg4ehgee"
  },
  "running": true,
  "command": "update",
  "starting_ports": [
    80,
    443,
    5555
  ],
  "_id": {
    "$oid": "57ebd2ed28447e1e09e72d6a"
  },
  "docker_image": "registry.vidazoo.com:5000/httpd"
}
```

missing parameters:
```
400
{
 "missing_parameters": "True"
}
```
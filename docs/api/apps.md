# Create app
create a new app inside the Nebula cluster, the docker_image is required with the rest of the parameters getting default values if not declared.

 **request**

```
POST /api/v2/apps/app_name HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-basic_auth_base64-here>
Content-Type: application/json
Cache-Control: no-cache
 
{
  "starting_ports": [80],
  "containers_per": {"server": 2},
  "env_vars": {"test": "test123"},
  "docker_image" : "nginx",
  "running": true,
  "volumes": [],
  "networks": ["nebula", "bridge"],
  "devices": [],
  "privileged": false,
  "rolling_restart": false
}
```

 **response example**

success
```
200
{
    "app_name": "app_name",
    "env_vars": {
        "test": "test123"
    },
    "app_id": 1,
    "devices": [],
    "privileged": false,
    "running": true,
    "containers_per": {
        "server": 2
    },
    "starting_ports": [
        80
    ],
    "volumes": [],
    "_id": {
        "$oid": "5c370a85ebdb54000edb8ef2"
    },
    "rolling_restart": false,
    "networks": [
        "nebula",
        "bridge"
    ],
    "docker_image": "nginx"
}
```

missing parameters
```
400
{
 "missing_parameters": ["running", "volumes"]
}
```

app already exists
```
403
 {
    "app_exists": true
}

```

# Delete app
delete an app from the nebula cluster, be careful as the only way to restore a deleted app is manually creating it with the same variables

 **request**

```
DELETE /api/v2/apps/app_name HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-basic_auth_base64-here>
Content-Type: application/json
Cache-Control: no-cache
```

 **response example**

success:
```
200
 {}
```

when trying to delete a non existing app:
```
403
{
    "app_exists": false
}
```

# List apps
list all apps managed in the current Nebula cluster

 **request**

```
GET /api/v2/apps HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-basic_auth_base64-here>
Content-Type: application/json
Cache-Control: no-cache
```

 **response example**

```
200
 {
  "apps": [
    "app_name"
  ]
}
```

# Get app config
get a specific Nebula app config 

 **request**

```
GET /api/v2/apps/app_name HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-basic_auth_base64-here>
Content-Type: application/json
Cache-Control: no-cache
```

 **response example**

```
200
{
    "app_name": "app_name",
    "env_vars": {
        "test": "app_name"
    },
    "app_id": 1,
    "devices": [],
    "privileged": false,
    "running": true,
    "containers_per": {
        "server": 2
    },
    "starting_ports": [
        80
    ],
    "volumes": [],
    "_id": {
        "$oid": "5c370a85ebdb54000edb8ef2"
    },
    "rolling_restart": false,
    "networks": [
        "nebula",
        "bridge"
    ],
    "docker_image": "nginx"
}
```

# Stop app
stop a running Nebula app

 **request**

```
POST /api/v2/apps/app_name/stop HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-basic_auth_base64-here>
Content-Type: application/json
Cache-Control: no-cache
```

 **response example**

```
202
{
    "app_name": "app_name",
    "env_vars": {
        "test": "app_name"
    },
    "app_id": 2,
    "devices": [],
    "privileged": false,
    "running": false,
    "containers_per": {
        "server": 2
    },
    "starting_ports": [
        80
    ],
    "volumes": [],
    "_id": {
        "$oid": "5c370a85ebdb54000edb8ef2"
    },
    "rolling_restart": false,
    "networks": [
        "nebula",
        "bridge"
    ],
    "docker_image": "nginx"
}
```

# Start app
start a Nebula app

 **request**

```
POST /api/v2/apps/app_name/start HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-basic_auth_base64-here>
Content-Type: application/json
Cache-Control: no-cache
```

 **response example**

```
202
{
    "app_name": "app_name",
    "env_vars": {
        "test": "app_name"
    },
    "app_id": 3,
    "devices": [],
    "privileged": false,
    "running": true,
    "containers_per": {
        "server": 2
    },
    "starting_ports": [
        80
    ],
    "volumes": [],
    "_id": {
        "$oid": "5c370a85ebdb54000edb8ef2"
    },
    "rolling_restart": false,
    "networks": [
        "nebula",
        "bridge"
    ],
    "docker_image": "nginx"
}
```

# Restart app
note that restarting an app also force pulling the latest version of the docker container so can be used as a form of deployment method assuming that the you overwritten the container tag in your docker registry with a newer version

 **request**

```
POST /api/v2/apps/app_name/restart HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-basic_auth_base64-here>
Content-Type: application/json
Cache-Control: no-cache
```

 **response example**

```
202
{
    "app_name": "app_name",
    "env_vars": {
        "test": "app_name"
    },
    "app_id": 4,
    "devices": [],
    "privileged": false,
    "running": true,
    "containers_per": {
        "server": 2
    },
    "starting_ports": [
        80
    ],
    "volumes": [],
    "_id": {
        "$oid": "5c370a85ebdb54000edb8ef2"
    },
    "rolling_restart": false,
    "networks": [
        "nebula",
        "bridge"
    ],
    "docker_image": "nginx"
}
```

# Update all of app params (POST)
update a Nebula app config, all the parameters needs to be overwritten at once (POST only), for updating only some of the app parameters use PUT instead, the docker_image is required with the rest of the parameters reverting to default values if not declared.

 **request**

```
POST /api/v2/apps/app_name/update HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-basic_auth_base64-here>
Content-Type: application/json
Cache-Control: no-cache
 
{
  "starting_ports": [80],
  "containers_per": {"server": 2},
  "env_vars": {"test": "test123"},
  "docker_image" : "nginx",
  "running": true,
  "volumes": [],
  "networks": ["nebula", "bridge"],
  "devices": [],
  "privileged": false,
  "rolling_restart": false
}
```

 **response example**

success:
```
202
{
    "app_name": "app_name",
    "env_vars": {
        "test": "app_name"
    },
    "app_id": 4,
    "devices": [],
    "privileged": false,
    "running": true,
    "containers_per": {
        "server": 2
    },
    "starting_ports": [
        80
    ],
    "volumes": [],
    "_id": {
        "$oid": "5c370a85ebdb54000edb8ef2"
    },
    "rolling_restart": false,
    "networks": [
        "nebula",
        "bridge"
    ],
    "docker_image": "nginx"
}
```

missing parameters:
```
400
{
 "missing_parameters": ["running", "volumes"]
}
```

# Update some app params (PUT / PATCH)
update a Nebula app config, accepts any combination of the app configuration params.

 **request**

```
PUT /api/v2/apps/app_name/update HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-basic_auth_base64-here>
Content-Type: application/json
Cache-Control: no-cache
 
{
    "rolling_restart": true,
    "containers_per": {"server": 1}
}
```

 **response example**

success:
```
202
{
    "app_name": "app_name",
    "env_vars": {
        "test": "app_name"
    },
    "app_id": 4,
    "devices": [],
    "privileged": false,
    "running": true,
    "containers_per": {
        "server": 1
    },
    "starting_ports": [
        80
    ],
    "volumes": [],
    "_id": {
        "$oid": "5c370a85ebdb54000edb8ef2"
    },
    "rolling_restart": true,
    "networks": [
        "nebula",
        "bridge"
    ],
    "docker_image": "nginx"
}
```

missing parameters:
```
400
{
 "missing_parameters": "True"
}
```
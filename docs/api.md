# Get api status
a simple webpage that can be used to monitor the API is working

 **request**

```
GET /api/v2/status HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-token-here>
Content-Type: application/json
Cache-Control: no-cache
```

 **response example**

success
```
200
{
    "api_available": true
}
```

# Create app
create a new app inside the Nebula cluster

 **request**

```
POST /api/v2/apps/app_name HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-token-here>
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
Authorization: Basic <your-token-here>
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
Authorization: Basic <your-token-here>
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
Authorization: Basic <your-token-here>
Content-Type: application/json
Cache-Control: no-cache
```

 **response example**

```
200
{
  "containers_per": {"cpu": 5},
  "app_name": "app_name",
  "env_vars": {
    "test": "blabla123",
    "test3t2t32": "tesg4ehgee"
  },
  "running": true,
  "volumes": ["/tmp:/tmp/1", "/var/tmp/:/var/tmp/1:ro"],
  "nebula": ["nebula"],
  "starting_ports": [
    80,
    443,
    5555
  ],
  "_id": {
    "$oid": "57ebd2ed28447e1e09e72d6a"
  },
  "docker_image": "httpd",
  "privileged": false,
  "devices": ["/dev/usb/hiddev0:/dev/usb/hiddev0:rwm"]
}
```

# Stop app
stop a running Nebula app

 **request**

```
POST /api/v2/apps/app_name/stop HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-token-here>
Content-Type: application/json
Cache-Control: no-cache
```

 **response example**

```
202
{
  "containers_per": {"cpu": 5},
  "app_name": "app_name",
  "env_vars": {
    "test": "blabla123",
    "test3t2t32": "tesg4ehgee"
  },
  "running": false,
  "networks": ["nebula"],
  "command": "stop",
  "volumes": ["/tmp:/tmp/1", "/var/tmp/:/var/tmp/1:ro"],
  "starting_ports": [
    80,
    443,
    5555
  ],
  "_id": {
    "$oid": "57ebd2ed28447e1e09e72d6a"
  },
  "docker_image": "httpd",
  "privileged": false,
  "devices": ["/dev/usb/hiddev0:/dev/usb/hiddev0:rwm"]
} 
```

# Start app
start a Nebula app

 **request**

```
POST /api/v2/apps/app_name/start HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-token-here>
Content-Type: application/json
Cache-Control: no-cache
```

 **response example**

```
202
 {
  "containers_per": {"cpu": 5},
  "app_name": "app_name",
  "env_vars": {
    "test": "blabla123",
    "test3t2t32": "tesg4ehgee"
  },
  "running": true,
  "volumes": ["/tmp:/tmp/1", "/var/tmp/:/var/tmp/1:ro"],
  "networks": ["nebula"],
  "command": "start",
  "starting_ports": [
    80,
    443,
    5555
  ],
  "_id": {
    "$oid": "57ebd2ed28447e1e09e72d6a"
  },
  "docker_image": "httpd",
  "privileged": false,
  "devices": ["/dev/usb/hiddev0:/dev/usb/hiddev0:rwm"]
}
```

# Restart app
note that restarting an app also force pulling the latest version of the docker container so can be used as a form of deployment method assuming that the you overwritten the container tag in your docker registry with a newer version

 **request**

```
POST /api/v2/apps/app_name/restart HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-token-here>
Content-Type: application/json
Cache-Control: no-cache
```

 **response example**

```
202
{
  "containers_per": {"cpu": 5},
  "app_name": "app_name",
  "env_vars": {
    "test": "blabla123",
    "test3t2t32": "tesg4ehgee"
  },
  "running": true,
  "command": "restart",
  "networks": ["nebula"],
  "volumes": ["/tmp:/tmp/1", "/var/tmp/:/var/tmp/1:ro"],
  "starting_ports": [
    80,
    443,
    5555
  ],
  "_id": {
    "$oid": "57ebd2ed28447e1e09e72d6a"
  },
  "docker_image": "httpd",
  "privileged": false,
  "devices": ["/dev/usb/hiddev0:/dev/usb/hiddev0:rwm"]
}
```

# Rolling restart app
Stops a container and then starts it up again, rolls for each container of the app running on the server 1 at a time with a 5 seconds between each container roll, note that rolling restarting an app also force pulling the latest version of the docker container so can be used as a form of deployment method assuming that the you overwritten the container tag in your docker registry with a newer version

 **request**

```
POST /api/v2/apps/app_name/roll HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-token-here>
Content-Type: application/json
Cache-Control: no-cache
```

 **response example**

```
202
{
  "containers_per": {"cpu": 5},
  "app_name": "app_name",
  "env_vars": {
    "test": "blabla123",
    "test3t2t32": "tesg4ehgee"
  },
  "running": true,
  "volumes": ["/tmp:/tmp/1", "/var/tmp/:/var/tmp/1:ro"],
  "networks": ["nebula]
  "command": "roll",
  "starting_ports": [
    80,
    443,
    5555
  ],
  "_id": {
    "$oid": "57ebd2ed28447e1e09e72d6a"
  },
  "docker_image": "httpd",
  "privileged": false,
  "devices": ["/dev/usb/hiddev0:/dev/usb/hiddev0:rwm"]
}
```

# Prune unused images
Prune unused images on all devices running an app that matches the app_name passed to the request path

 **request**

```
POST /api/v2/apps/app_name/prune HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-token-here>
Content-Type: application/json
Cache-Control: no-cache
```

 **response example**

```
202
{
  "containers_per": {"cpu": 5},
  "app_name": "app_name",
  "env_vars": {
    "test": "blabla123",
    "test3t2t32": "tesg4ehgee"
  },
  "running": true,
  "volumes": ["/tmp:/tmp/1", "/var/tmp/:/var/tmp/1:ro"],
  "networks": ["nebula]
  "command": "prune",
  "starting_ports": [
    80,
    443,
    5555
  ],
  "_id": {
    "$oid": "57ebd2ed28447e1e09e72d6a"
  },
  "docker_image": "httpd",
  "privileged": false,
  "devices": ["/dev/usb/hiddev0:/dev/usb/hiddev0:rwm"]
}
```

# Update all of app params (POST)
update a Nebula app config, all the parameters needs to be overwritten at once (POST only), for updating only some of the app parameters use PUT instead.

 **request**

```
POST /api/v2/apps/app_name/update HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-token-here>
Content-Type: application/json
Cache-Control: no-cache
 
{
    "starting_ports": [80, 443, 5555],
    "containers_per": {"cpu": 5},
    "env_vars": {"test": "blabla123", "test3t2t32": "tesg4ehgee"},
    "volumes": ["/tmp:/tmp/1", "/var/tmp/:/var/tmp/1:ro"],
    "docker_image" : "httpd",
    "running": true,
    "networks": ["nebula]
    "privileged": false,
    "devices": ["/dev/usb/hiddev0:/dev/usb/hiddev0:rwm"]
}
```

 **response example**

success:
```
202
 {
  "containers_per": {"cpu": 5},
  "app_name": "app_name",
  "env_vars": {
    "test": "blabla123",
    "test3t2t32": "tesg4ehgee"
  },
  "running": true,
  "command": "update",
  "networks": ["nebula]
  "starting_ports": [
    80,
    443,
    5555
  ],
  "_id": {
    "$oid": "57ebd2ed28447e1e09e72d6a"
  },
  "docker_image": "httpd",
  "privileged": false,
  "devices": ["/dev/usb/hiddev0:/dev/usb/hiddev0:rwm"]
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
Authorization: Basic <your-token-here>
Content-Type: application/json
Cache-Control: no-cache
 
{
    "starting_ports": [80, 443, 6666],
    "containers_per": {"server": 2}
}
```

 **response example**

success:
```
202
 {
  "containers_per": {"server": 2},
  "app_name": "app_name",
  "env_vars": {
    "test": "blabla123",
    "test3t2t32": "tesg4ehgee"
  },
  "running": true,
  "volumes": ["/tmp:/tmp/1", "/var/tmp/:/var/tmp/1:ro"],
  "command": "update",
  "networks": ["nebula]
  "starting_ports": [
    80,
    443,
    6666
  ],
  "_id": {
    "$oid": "57ebd2ed28447e1e09e72d6a"
  },
  "docker_image": "httpd",
  "privileged": false,
  "devices": ["/dev/usb/hiddev0:/dev/usb/hiddev0:rwm"]
}
```

missing parameters:
```
400
{
 "missing_parameters": "True"
}
```
# Get api status
a simple endpoint that can be used to monitor the API is working

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
Authorization: Basic <your-token-here>
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
Authorization: Basic <your-token-here>
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
Authorization: Basic <your-token-here>
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

# Prune unused images on all device
Prune unused images on all devices

 **request**

```
POST /api/v2/prune HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-token-here>
Content-Type: application/json
Cache-Control: no-cache
```

 **response example**

```
202
{
    "prune_ids": {
        "test": 544,
        "test123": 222
    }
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
Authorization: Basic <your-token-here>
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

# list a device group info
a special endpoint which the devices check every (configurable with the "nebula_manager_check_in_time" param on the workers) X seconds that returns a cached (cache time configurable by the "cache_time" param on the manager) info of all apps of said device_group along with all the the data needed to get the device to match the needed configuration.

 **request**

```
GET /api/v2/device_groups/device_group_name/info HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-token-here>
Content-Type: application/json
Cache-Control: no-cache
```

 **response example**

success:
```
200
{
    "prune_id": 544,
    "apps_list": [
        "test",
        "test123"
    ],
    "apps": [
        {
            "app_name": "test",
            "env_vars": {
                "test": "blabla123",
                "test3t2t32": "tesg4ehgee"
            },
            "app_id": 319,
            "devices": [],
            "privileged": false,
            "running": true,
            "containers_per": {
                "server": 1
            },
            "starting_ports": [
                {
                    "80": "80"
                },
                8888
            ],
            "volumes": [
                "/tmp:/tmp/1",
                "/var/tmp/:/var/tmp/1:ro"
            ],
            "_id": {
                "$oid": "5c2c767959be4c000ed3653f"
            },
            "rolling_restart": false,
            "networks": [
                "nebula",
                "bridge"
            ],
            "docker_image": "nginx:alpine"
        },
        {
            "app_name": "test123",
            "env_vars": {
                "test": "blabla123",
                "test3t2t32": "tesg4ehgee"
            },
            "app_id": 6,
            "devices": [],
            "privileged": false,
            "running": true,
            "containers_per": {
                "cpu": 1
            },
            "starting_ports": [
                {
                    "333": "80"
                },
                777
            ],
            "volumes": [
                "/tmp:/tmp/1",
                "/var/tmp/:/var/tmp/1:ro"
            ],
            "_id": {
                "$oid": "5c2c767659be4c000ed3653e"
            },
            "rolling_restart": false,
            "networks": [
                "nebula",
                "bridge"
            ],
            "docker_image": "httpd:alpine"
        }
    ],
    "device_group_id": 116
}
```

# list a device group
list a device group config

 **request**

```
GET /api/v2/device_groups/device_group_name HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-token-here>
Content-Type: application/json
Cache-Control: no-cache
```

 **response example**

```
{
    "prune_id": 544,
    "_id": {
        "$oid": "5c2cc6849d723e6c88ba466e"
    },
    "apps": [
        "test",
        "test123"
    ],
    "device_group_id": 116,
    "device_group": "device_group_name"
}
```

# list device groups
list all device groups

 **request**

```
GET /api/v2/device_groups HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-token-here>
Content-Type: application/json
Cache-Control: no-cache
```

 **response example**

```
{
    "device_groups": [
        "test",
        "test123"
    ]
}
```

# create a device group
create a device group

 **request**

```
POST /api/v2/device_groups/device_group_name HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-token-here>
Content-Type: application/json
Cache-Control: no-cache

{
    "apps": [
        "test",
        "test123"
    ]
}
```

 **response example**

```
200
{
    "prune_id": 544,
    "_id": {
        "$oid": "5c2cc6849d723e6c88ba466e"
    },
    "apps": [
        "test",
        "test123"
    ],
    "device_group_id": 116,
    "device_group": "device_group_name"
}
```

# delete a device group
delete a device group config

 **request**

```
DELETE /api/v2/device_groups/device_group_name HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-token-here>
Content-Type: application/json
Cache-Control: no-cache
```

 **response example**

```
200
{}
```

# update a device group
update a device group

 **request**

```
POST /api/v2/device_groups/device_group_name HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-token-here>
Content-Type: application/json
Cache-Control: no-cache

{
    "apps": [
        "test",
        "test123"
    ]
}
```

 **response example**

```
202
{
    "prune_id": 544,
    "_id": {
        "$oid": "5c2cc6849d723e6c88ba466e"
    },
    "apps": [
        "test",
        "test123"
    ],
    "device_group_id": 116,
    "device_group": "device_group_name"
}
```


# prune images on a device group
Prune unused images on  devices that are part of a given device group

 **request**

```
POST /api/v2/device_groups/device_group_name/prune HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-token-here>
Content-Type: application/json
Cache-Control: no-cache
```

 **response example**

```
202
{
    "prune_id": 545,
    "_id": {
        "$oid": "5c2cc6849d723e6c88ba466e"
    },
    "apps": [
        "test",
        "test123"
    ],
    "device_group_id": 117,
    "device_group": "test"
}
```

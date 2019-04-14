# list a device group info
a special endpoint which the devices check every (configurable with the "nebula_manager_check_in_time" param on the workers) X seconds that returns a cached (cache time configurable by the "cache_time" param on the manager) info of all apps of said device_group along with all the the data needed to get the device to match the needed configuration.

 **request**

```
GET /api/v2/device_groups/device_group_name/info HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-basic_auth_base64-here>
Content-Type: application/json
Cache-Control: no-cache
```

 **response example**

success:
```
200
{
    "apps": [
        {
            "app_name": "test",
            "env_vars": {
                "test": "blabla123",
                "test3t2t32": "tesg4ehgee"
            },
            "app_id": 498,
            "running": true,
            "containers_per": {
                "mem": 1024
            },
            "starting_ports": [
                {
                    "80": "80"
                },
                8888
            ],
            "networks": [
                "nebula",
                "bridge"
            ],
            "docker_image": "httpd",
            "devices": [],
            "volumes": [
                "/tmp:/tmp/1",
                "/var/tmp/:/var/tmp/1:ro"
            ],
            "privileged": false,
            "rolling_restart": false,
            "app_token": "bb627c20-e5e9-402c-9f44-111889da2c39",
            "schedule": "0 0 * * *"
        },
        {
            "app_name": "test123",
            "env_vars": {
                "test": "blabla123",
                "test3t2t32": "tesg4ehgee"
            },
            "app_id": 7,
            "running": true,
            "containers_per": {
                "cpu": 1
            },
            "starting_ports": [
                {
                    "888": "888"
                }
            ],
            "networks": [
                "nebula",
                "bridge"
            ],
            "docker_image": "httpd:alpine",
            "devices": [],
            "volumes": [
                "/tmp:/tmp/1",
                "/var/tmp/:/var/tmp/1:ro"
            ],
            "privileged": false,
            "rolling_restart": false,
            "app_token": "680b735b-fd64-43a7-b0b8-4b3905e65352"
        }
    ],
    "apps_list": [
        "test",
        "test123"
    ],
    "prune_id": 125,
    "cron_jobs": [
        {
            "cron_job_id": 1,
            "cron_job_name": "test",
            "schedule": "0 * * * *",
            "env_vars": {
                "test": "test123"
            },
            "docker_image": "nginx",
            "running": true,
            "networks": [
                "nebula",
                "bridge"
            ],
            "volumes": [],
            "devices": [],
            "privileged": false
        }
    ],
    "cron_jobs_list": [
        "test"
    ],
    "device_group_id": 31
}
```

# list a device group
list a device group config

 **request**

```
GET /api/v2/device_groups/device_group_name HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-basic_auth_base64-here>
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
    "cron_jobs": [
        "test"
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
Authorization: Basic <your-basic_auth_base64-here>
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
Authorization: Basic <your-basic_auth_base64-here>
Content-Type: application/json
Cache-Control: no-cache

{
    "apps": [
        "test",
        "test123"
    ],
    "cron_jobs": [
        "test"
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
    "device_group": "device_group_name",
    "cron_jobs": [
        "test"
    ]
}
```

# delete a device group
delete a device group config

 **request**

```
DELETE /api/v2/device_groups/device_group_name HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-basic_auth_base64-here>
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
POST /api/v2/device_groups/device_group_name/update HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-basic_auth_base64-here>
Content-Type: application/json
Cache-Control: no-cache

{
    "apps": [
        "test",
        "test123"
    ],
    "cron_jobs": [
        "test"
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
    "device_group": "device_group_name",
    "cron_jobs": [
        "test"
    ]
}
```

# prune images on a device group
Prune unused images on  devices that are part of a given device group

 **request**

```
POST /api/v2/device_groups/device_group_name/prune HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-basic_auth_base64-here>
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
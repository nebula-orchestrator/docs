# list cron jobs
list all cron jobs

 **request**

```
GET /api/v2/cron_jobs HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-basic_auth_base64-here>
Content-Type: application/json
Cache-Control: no-cache
```

 **response example**

```
200
{
    "cron_jobs": [
    "test"
    ]
}
```

# delete a cron job
delete a cron job config

 **request**

```
DELETE /api/v2/cron_jobs/cron_job_name HTTP/1.1
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

# list a cron job
list a cron job config

 **request**

```
GET /api/v2/cron_jobs/cron_job_name HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-basic_auth_base64-here>
Content-Type: application/json
Cache-Control: no-cache
```

 **response example**

```
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
```

# create a cron job
create a cron job

 **request**

```
200
POST /api/v2/cron_jobs/cron_job_name HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-basic_auth_base64-here>
Content-Type: application/json
Cache-Control: no-cache

{
  "env_vars": {"test": "test123"},
  "docker_image" : "nginx",
  "running": true,
  "volumes": [],
  "networks": ["nebula", "bridge"],
  "devices": [],
  "privileged": false,
  "schedule": "0 * * * *"
}
```

 **response example**

```
200
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
```

# Update some cron job params (PUT / PATCH)
update a Nebula cron job config, accepts any combination of the cron job configuration params.

 **request**

```
PUT /api/v2/cron_jobs/cron_job_name/update HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-basic_auth_base64-here>
Content-Type: application/json
Cache-Control: no-cache
 
{
	"schedule": "0 0 * * *",
	"docker_image": "httpd"
}
```

 **response example**

success:
```
202
{
    "_id": {
        "$oid": "5cb309239d723e5e3d22d0a0"
    },
    "cron_job_id": 11,
    "cron_job_name": "test",
    "schedule": "0 0 * * *",
    "env_vars": {
        "test": "test123"
    },
    "docker_image": "httpd",
    "running": true,
    "networks": [
        "nebula",
        "bridge"
    ],
    "volumes": [],
    "devices": [],
    "privileged": false
}
```

missing parameters:
```
400
{
 "missing_parameters": "True"
}
```

# Update all cron job params (POST)
update a Nebula cron job config, requires all of the cron job configuration params.

 **request**

```
POST /api/v2/cron_jobs/cron_job_name/update HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-basic_auth_base64-here>
Content-Type: application/json
Cache-Control: no-cache
 
{
	"schedule": "0 0 * * *",
	"docker_image": "httpd"
}
```

 **response example**

success:
```
202
{
    "_id": {
        "$oid": "5cb309239d723e5e3d22d0a0"
    },
    "cron_job_id": 11,
    "cron_job_name": "test",
    "schedule": "0 0 * * *",
    "env_vars": {
        "test": "test123"
    },
    "docker_image": "httpd",
    "running": true,
    "networks": [
        "nebula",
        "bridge"
    ],
    "volumes": [],
    "devices": [],
    "privileged": false
}
```

missing parameters:
```
400
{
 "missing_parameters": "True"
}
```

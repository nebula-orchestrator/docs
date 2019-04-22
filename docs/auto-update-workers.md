# Automatically update workers

!!! warning
    Automatically updating workers is not recommended for production use.

If you want to have the worker containers Automatically update you can set them to use the "latest" tag of the worker and run the following nebula cron_job which uses [ouroboros](https://github.com/pyouroboros/ouroboros) to ensure the worker containers are updated whenever a newer version is released.

```bash
curl -X POST \
  http://your_nebula_manager_fqdn/api/v2/cron_jobs/auto_upgrade_workers \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer your_bearer_token' \
  -H 'cache-control: no-cache' \
  -d '{
  "env_vars": {"RUN_ONCE": "true", "MONITOR":"worker", "CLEANUP":"true"},
  "docker_image" : "pyouroboros/ouroboros",
  "running": true,
  "volumes": ["/var/run/docker.sock:/var/run/docker.sock"],
  "networks": ["nebula", "bridge"],
  "devices": [],
  "privileged": false,
  "schedule": "0 * * * *"
}'
```

Make sure to change the following to suit your need:

* your_nebula_manager_fqdn - the FQDN where you connect to your nebula manager.
* MONITOR envvar - will need to be the same as the container name you give your worker ("worker" in this example).
* "schedule" - will need to be a valid cron of when you want the auto update check to take place at.
* "your_bearer_token" - the token to auth to your nebula manager, basic auth can also be used by switching from Bearer to Basic.

You will then need to add the new cron_job to every device_group you want the workers of to be auto_updated, for example:

```bash
curl -X PUT \
  http://your_nebula_manager_fqdn/api/v2/device_groups/device_group_you_want_to_auto_update_worker/update \
  -H 'Authorization: Bearer your_bearer_token' \
  -H 'Content-Type: application/json' \
  -H 'cache-control: no-cache' \
  -d '{
    "cron_jobs": ["auto_upgrade_workers"]
}'
```

Make sure to change the following to suit your need:

* your_nebula_manager_fqdn - the FQDN where you connect to your nebula manager.
* device_group_you_want_to_auto_update_worker - the name of the device_group you want to have auto updated.
* "your_bearer_token" - the token to auth to your nebula manager, basic auth can also be used by switching from Bearer to Basic.

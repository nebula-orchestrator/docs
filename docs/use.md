After you have Nebula installed using it is rather straightforward, you make an API request to the manager every time you want to change one of the apps (deploying new version, update envvar, etc...), aside from that nebula will keep everything running with the latest version & if you want to scale out you simply add more servers of the component you want to add more.

# Configuring Nebula

Configuring can be done either via envvars or via replacing the attached config/conf.json to one with your own variables, more info about possible config variables & the config file location can be found at the [config page](http://nebula.readthedocs.io/en/latest/config/)

# Creating & configuring apps

Let's say your devices are a bunch of smart speakers (like echo dot or google home) and you want to manage them using Nebula:

1. first thing you will want to do is create an nebula app that will run the container of your smart speaker and all the needed parameters for it (frontpage for initial user configuration, envvars, etc), let's create an app named "smart_speaker" to do that:

```
POST /api/v2/apps/smart_speaker HTTP/1.1
Host: <your-manager>
Authorization: Basic <your-basic-auth>
Content-Type: application/json
Cache-Control: no-cache

{
  "starting_ports": [{"80": "80"}],
  "containers_per": {"server": 1},
  "env_vars": {"SPEAKER_ENV": "prod"},
  "docker_image" : "registry.awsomespeakersinc.com:5000/speaker:v25",
  "running": true,
  "volumes": ["/etc/speaker/conf:/etc/speaker/conf:rw"],
  "networks": ["nebula", "bridge"],
  "devices": [],
  "privileged": false,
  "rolling_restart": false
}
```

2. now that we have an app created we will need to attach said app to a device_group, each device_group consists of a list of apps that are designed to run on each device that is part of that device_group, let's create a device_group named "speakers" and attach it the "smart_speaker" app to it:

```
POST /api/v2/device_groups/speakers HTTP/1.1
Host: <your-manager>
Authorization: Basic <your-basic-auth>
Content-Type: application/json
cache-control: no-cache
{
    "apps": [
        "smart_speaker"
    ]
}
```

3. now that we have the nebula app & device_group configured in nebula all that's left is to start the nebula worker container on each of the smart speaker devices and to have the "DEVICE_GROUP" envvar configured to "speakers" (can also be done via the configuration file) - this will tell the device it's part of the "speakers" device_group and will sync in with the managers to match it's running apps configuration to the one needed every (configurable) X seconds.

Your done, each change you now make in nebula will be synced to all of your devices.

# Scheduled cron jobs

Similar to how apps are created cron jobs can also be scheduled to run on all workers:

1. we create a cron_job that manages the cron schedule, container image, envvar, etc - it's important to have that container exit when done, the following example will run every hour (0 * * * *):

```
POST /api/v2/cron_jobs/smart_speaker_cron HTTP/1.1
Host: <your-manager>
Authorization: Basic <your-basic-auth>
Content-Type: application/json
Cache-Control: no-cache

{
  "env_vars": {"RUN_ONCE": "true", "CLEANUP":"true"},
  "docker_image" : "registry.awsomespeakersinc.com:5000/speaker_clean_up_cron:v7",
  "running": true,
  "volumes": ["/var/run/docker.sock:/var/run/docker.sock"],
  "networks": ["nebula", "bridge"],
  "devices": [],
  "privileged": false,
  "schedule": "0 * * * *"
}
```

2. we then add said cron to our device_group, as we already have a device_group for the smart speakers created in the previous step where we configured the main app we will update said device_group config:

```
PU /api/v2/device_groups/speakers/update HTTP/1.1
Host: <your-manager>
Authorization: Basic <your-basic-auth>
Content-Type: application/json
cache-control: no-cache
{
    "cron_jobs": [
        "smart_speaker_cron"
    ]
}
```

Now as the workers on all the smart speakers are already configured from the app step to be part of the "speakers" device_group they will all receive the configuration to run the new cron automatically without any additional steps needed.

# Backup & restore

As the only stateful part of the entire design is the MongoDB backing it up using any of the best practice methods available to it is sufficient, that being said it might be a good idea to also have your version of the manager & worker containers available in more then one registry in case of issues with your chosen registry supplier (or self hosted one).
Restoring in case of a complete disaster is simply a matter of recreating all the components using the installing method described above and populating your MongoDB with the most recent backup of the MongoDB database.

# Health checks

Nebula utilizes Dockerfile builtin [healthcheck](https://docs.docker.com/engine/reference/builder/#healthcheck) capabilities, you configure them inside your Dockerfile and Nebula has an out of band process which looks every few seconds for any containers marked as unhealthy as a result of the healthcheck, any container found to be unhealthy is then restarted.
 
!!! note 
    The restart of a container at an unhealthy status is equivalent to running a "docker restart" with the docker CLI on it.

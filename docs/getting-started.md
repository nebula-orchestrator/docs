# Hello World tutorial

The easiest way to get started is usually with a hands on approach, the following tutorial will use [docker-compose](https://docs.docker.com/compose/) to set a local Nebula cluster on your machine that includes MongoDB, the manager & the worker (which normally you will want be different devices but for testing this is sufficient), it of course requires docker & docker-compose installed so if you don't have them install them first.

!!! tip
    You can run the following and skip to step 4 if you don't want to change the docker-compose to add a private Docker registry access:
    
```bash
curl -L "https://raw.githubusercontent.com/nebula-orchestrator/docs/master/examples/hello-world/docker-compose.yml" -o docker-compose.yml && sudo docker-compose up -d
```


1. First get the [docker-compose.yml](https://github.com/nebula-orchestrator/docs/blob/master/examples/hello-world/docker-compose.yml) of this tutorial and save it locally on your machine
2. Nebula is geared towards using a private registry but will also work with docker hub, to use your own user\pass (by default no auth is used) edit the docker-compose.yml by entering your docker hub user & password into "REGISTRY_AUTH_USER" & "REGISTRY_AUTH_PASSWORD" under the "worker" container, if your using a private registry change the "REGISTRY_HOST" variable as well to point to your private registry, if you are planning on only using public images you can keep the settings as is and use no Docker registry auth.
3. from the directory where you saved docker-compose.yml at (same name is important) run `docker-compose up -d` (you might need to `sudo su` first if you didn't set your user to be part of the docker group), don't worry if you see the worker & manager restarting, it's because the mongo & rabbit containers take a couple of seconds to initialize.
4. You now have a running Nebula cluster, lets use Curl to create an nginx app to fill the "example" app that we will run as part of our device_group:

        curl -X POST \
          http://127.0.0.1/api/v2/apps/example \
          -H 'authorization: Basic bmVidWxhOm5lYnVsYQ==' \
          -H 'cache-control: no-cache' \
          -H 'content-type: application/json' \
          -d '{
          "starting_ports": [{"81":"80"}],
          "containers_per": {"server": 1},
          "env_vars": {},
          "docker_image" : "nginx",
          "running": true,
          "volumes": ["/tmp:/tmp/1", "/var/tmp/:/var/tmp/1:ro"],
          "networks": ["nebula"],
          "privileged": false,
          "devices": [],
          "rolling_restart": false
        }'
        
5. Now that we have an app let's create an the "example" device_group with the "example" app part of it by using another curl command:

        curl -X POST \
          http://127.0.0.1/api/v2/device_groups/example \
          -H 'Authorization: Basic bmVidWxhOm5lYnVsYQ==' \
          -H 'Content-Type: application/json' \
          -H 'cache-control: no-cache' \
          -d '{
            "apps": [
                "example"
            ]
        }'

6. Either wait for the changes to catch (usually few seconds at most) or restart the worker container, you now have your first nebula worker (try logging into 127.0.0.1:81 in your browser to see), because the network is internal in this tutorial you can only run more on the same machine (which kinda defeats the purpose) but after you deploy Nebula by following the [install](install.md) guide you can run as many workers as you need by having multiple servers running the same worker container with the same envvars\config file.

## One command run

Running the following command will run the "Hello World" tutorial described above in an automated fashion, this makes it easier to play around with the API, it's still recommended to learn the tutorial above at least once to better understand the system install process and architecture:

```bash
curl -L "https://raw.githubusercontent.com/nebula-orchestrator/docs/master/examples/hello-world/start_example_nebula_cluster.sh" -o start_example_nebula_cluster.sh && sudo sh start_example_nebula_cluster.sh
```

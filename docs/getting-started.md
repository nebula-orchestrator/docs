# Hello World tutorial

The easiest way to get started is usually with a hands on approach, the following tutorial will use docker-compose to set a local Nebula cluster on your machine, it of course requires docker & docker-compose installed so if you don't have them install them first.

1. Note that some linux systems have epmd installed (Ubuntu included) which the following rabbitmq container requires so if your having problems with rabbit refusing to run try killing the host epmd and\or host rabbitmq-server for the duration of this tutorial
2. First get the [docker-compose.yml](https://github.com/nebula-orchestrator/docs/blob/master/examples/hello-world/docker-compose.yml) of this tutorial and save it locally on your machine
3. Nebula is geared towards using a private registry but will also work with docker hub, to use your own user\pass (by default no auth is used) edit the docker-compose.yml by entering your docker hub user & password into "REGISTRY_AUTH_USER" & "REGISTRY_AUTH_PASSWORD" under the "worker" container, if your using a private registry change the "REGISTRY_HOST" variable as well to point to your private registry.
from the directory where you saved docker-compose.yml at (same name is important) run `docker-compose up -d` (you might need to `sudo su` first if you didn't set your user to be part of the docker group), don't worry if you see the worker-manager & api-manager restarting, it's because the mongo & rabbit containers aren't configured yet so they fail to connect to it
4. Do to the MongoDB & RabbitMQ initialization taking a few seconds you might see the API restart a couple of times.
5. You now have a running Nebula cluster, lets use Curl to create an nginx app to fill the "example" APP_NAME app that the worker-manager has set to manage:

        curl -X POST \
          http://127.0.0.1/api/apps/example \
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
          "devices": []
        }'
        
6. Either wait for the changes to catch (usually few seconds at most) or restart the worker-manager container, you now have your first nebula worker (try logging into 127.0.0.1:81 in your browser to see), because the network is internal in this tutorial you can only run more on the same machine (which kinda defeats the purpose) but after you deploy Nebula by following the [install](install.md) guide you can run as many workers as you need by having multiple servers running the same worker-manager container with the same envvars\config file.

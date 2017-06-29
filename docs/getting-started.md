# Hello World tutorial

The easiest way to get started is usually with a hands on approch, the following tutorial will use docker-compose to set a local Nebula cluster on your machine, it of course requires docker & docker-compose installed so if you don't have them install them first.
Note that some linux systems have epmd installed which the following rabbitmq container requires so if your having problems with rabbit refusing to run try killing the host epmd and\or host rabbitmq-server for the duration of this tutorial

1. First get the [docker-compose.yml](https://github.com/nebula-orchestrator/docs/blob/master/examples/hello-world/docker-compose.yml) of this tutorial and save it locally on your machine
2. Nebula is geared towards using a private registry but will also work with docker hub, it does require a user so edit the docker-compose.yml by entering your docker hub user & password into "REGISTRY_AUTH_USER" & "REGISTRY_AUTH_PASSWORD", if your using a private registry change the "REGISTRY_HOST" variable as well to point to your private registry.
from the directory where you saved docker-compose.yml at (same name is important) run `docker-compose up -d`, don't worry if you see the worker-manager & api-manager restarting, it's because the mongo & rabbit containers aren't configured yet so they fail to connect to it
3. Create the database user & schema using the following commands:

        docker exec -it mongo mongo
        use nebula
        db.createUser(
           {
             user: "nebula",
             pwd: "nebula",
             roles: [ "readWrite" ]
           }
        )
        

4. Exit the container (ctrl-d)
5. All that's left is to create the rabbit user and vhost

        docker exec -it rabbit sh
        rabbitmqctl add_vhost nebula
        rabbitmqctl add_user nebula nebula
        rabbitmqctl set_permissions -p nebula nebula ".*" ".*" ".*"
        

6. Exit the container (ctrl-d)
7. Either wait for the changes to catch (usually few seconds at most) or the api-manager container
8. You now have a running Nebula cluster, lets use Curl to create an nginx app to fill the "example" APP_NAME app that the worker-manager has set to manage:

        curl -X POST \
          http://127.0.0.1/api/apps/example \
          -H 'authorization: Basic bmVidWxhOm5lYnVsYQ==' \
          -H 'cache-control: no-cache' \
          -H 'content-type: application/json' \
          -d '{
          "starting_ports": [80],
          "containers_per": {"server": 1},
          "env_vars": {},
          "docker_image" : "nginx",
          "running": true,
          "network_mode": "host"
        }'
        
9. Either wait for the changes to catch (usually few seconds at most) or restart the worker-manager container, you now have your first nebula worker
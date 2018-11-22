#!/usr/bin/env bash

# run the following to start the API, RabbitMQ, MongoDB & an example worker preconfigured to connect to an app named "example" all on one server
sudo curl -L "https://raw.githubusercontent.com/nebula-orchestrator/docs/master/examples/hello-world/docker-compose.yml" -o docker-compose.yml && sudo docker-compose up -d

# wait ~10 seconds for everything to finish the initial boot
sleep 10

# run the curl below to create the example application
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

# give instructions on how to other other devices
echo "want more remote devices to join? just run the following on them:"
echo "sudo docker run --rm -v /var/run/docker.sock:/var/run/docker.sock --env RABBIT_HOST=<server_exterior_fqdn> --env RABBIT_VHOST=/ --env RABBIT_USER=nebula --env RABBIT_PASSWORD=nebula --env APP_NAME=example --name nebula-worker nebulaorchestrator/worker"

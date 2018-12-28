#!/usr/bin/env bash

# run the following to start the API, RabbitMQ, MongoDB & an example worker preconfigured to connect to an app named "example" all on one server
sudo curl -L "https://raw.githubusercontent.com/nebula-orchestrator/docs/master/examples/hello-world/docker-compose.yml" -o docker-compose.yml && sudo docker-compose up -d

# wait ~20 seconds for everything to finish the initial boot
sleep 20

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

# give instructions on how to other other devices & a link to the documentation
echo ""
echo "want more remote devices to join? just run the following on them:"
echo "sudo docker run -d --restart unless-stopped -v /var/run/docker.sock:/var/run/docker.sock --env RABBIT_HOST=<server_exterior_fqdn> --env RABBIT_VHOST=/ --env RABBIT_USER=nebula --env RABBIT_PASSWORD=nebula --env APP_NAME=example --name nebula-worker nebulaorchestrator/worker"
echo ""
echo "you can now connect to each device on port 81 via your browser to see and example nginx running"
echo ""
echo "feel free to play around with Nebula API https://nebula.readthedocs.io/en/latest/api/ on port 80 with the basic auth user & pass being 'nebula' or to read more about it at https://nebula.readthedocs.io/en/latest/"

#!/usr/bin/env bash

# run the following to start the API, MongoDB & an example worker preconfigured to connect to an app named "example" all on one server
sudo curl -L "https://raw.githubusercontent.com/nebula-orchestrator/docs/master/examples/hello-world/docker-compose.yml" -o docker-compose.yml
sudo docker-compose pull
sudo docker-compose up -d

# wait until the manager is online
until $(curl --output /dev/null --silent --head --fail -H 'authorization: Basic bmVidWxhOm5lYnVsYQ==' -H 'cache-control: no-cache' http://127.0.0.1/api/status); do
    echo "Waiting on the manager API to become available..."
    sleep 3
done

# run the curl below to create the example app
echo "Creating an example app (creatively) named example"
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
          "devices": []
          "rolling_restart": false
        }'

# run the curl below to create the example device_group
echo "Creating an example device_group (creatively) named example"
curl -X POST \
          http://127.0.0.1/api/v2/device_groups/example \
          -H 'authorization: Basic bmVidWxhOm5lYnVsYQ==' \
          -H 'cache-control: no-cache' \
          -H 'content-type: application/json' \
          -d '{
              "apps": ["example"]
        }'

# wait until the example nginx is online
until $(curl --output /dev/null --silent --head --fail -H 'cache-control: no-cache' http://127.0.0.1:81/); do
    echo "Waiting on the example work container to become available..."
    sleep 3
done

# give instructions on how to other other devices & a link to the documentation
echo ""
echo "Example nebula cluster is now ready for use"
echo ""
echo "Want more remote devices to join? just run the following on them:"
echo "sudo docker run -d --restart unless-stopped -v /var/run/docker.sock:/var/run/docker.sock --env DEVICE_GROUP=example --env REGISTRY_HOST=https://index.docker.io/v1/ --env MAX_RESTART_WAIT_IN_SECONDS=0 --env NEBULA_MANAGER_AUTH_USER=nebula --env NEBULA_MANAGER_AUTH_PASSWORD=nebula --env NEBULA_MANAGER_AUTH_HOST=<your_manager_server_ip_or_fqdn> --env NEBULA_MANAGER_AUTH_PORT=80 --env nebula_manager_protocol=http --env nebula_manager_check_in_time=5 --name nebula-worker nebulaorchestrator/worker"
echo ""
echo "You can now connect to each device on port 81 via your browser to see and example nginx running"
echo ""
echo "Feel free to play around with Nebula API https://nebula.readthedocs.io/en/latest/api/ on port 80 with the basic auth user & pass being 'nebula' or to read more about it at https://nebula.readthedocs.io/en/latest/"

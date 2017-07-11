After you have Nebula installed using it is rather straightforward, you make an API request to the api-manager every time you want to change one of the apps (deploying new version, update envvar, etc...), aside from that nebula will keep everything running with the latest version & if you want to scale out you simply add more servers of the component you want to add more.

# Configuring Nebula

Configuring can be done either via envvars or via replacing the attached conf.json to one with your own variables, more info about possible config variables & the config file location can be found at the [config page](http://nebula.readthedocs.io/en/latest/config/)

# Creating & configuring apps

Let's say you want to create an app named "site" which hosts your website, to do that on your nebula cluster you will do the following:

1. create an app named "site" in Nebula using Nebula API that includes your site container & all required settings "envvar"

```
POST /api/apps/site HTTP/1.1
Host: <your-api-manager>
Authorization: Basic <your-basic-auth>
Content-Type: application/json
Cache-Control: no-cache

{
  "starting_ports": [{"81": "80"}],
  "containers_per": {"cpu": 3},
  "env_vars": {"test": "test123"},
  "docker_image" : "<your-site-container-image>",
  "running": true,
  "network_mode": "bridge"
}
```

The command above will mean that on each worker node with the "site" APP_NAME tag there will be 3 containers per cpu created of said image, the container will run from port 81 up to 81+number of containers, with each of them binding to port 80 inside the container.

2. You will also need a way to load balance between all of the "site containers" & redirect the servers port 80 traffic to them, for that create another nebula app named "lb" for load balancing

```
POST /api/apps/lb HTTP/1.1
Host: <your-api-manager>
Authorization: Basic <your-basic-auth>
Content-Type: application/json
Cache-Control: no-cache

{
  "starting_ports": [{"80": "80"}],
  "containers_per": {"cpu": 3},
  "env_vars": {"test": "test123"},
  "docker_image" : "<your-lb-container-image>",
  "running": true,
  "network_mode": "host"
}
```

This will use the host network so all you need is a LB that binds to port 80 and load balances the traffic between ports 81 to 81+<number_of_site_containers>,an example HAPRoxy config which handle the following can be found at  [example-config](https://github.com/nebula-orchestrator/nebula/blob/master/docs/haproxy.cfg) 


3. Create worker nodes with the APP_NAME="site,lb" envvar tag for said servers to know they need to load both the "lb" & the "site" apps
4. Create a sever LB layer, in AWS using ELB is great for that but any standard LB will do.

Your done, each request will now be directed to one of your "site" containers & should your site takeoff you can scale said architecture to handle billions of requests easily by adding more servers with the tag, or if you want to change your site a single API call will update all of your containers to a new version.

# Backup & restore

As the only stateful part of the entire design is the MongoDB backing up mongo using any of the best practice methods available to it, is sufficient, that being said it might be a good idea to also have your version of the api-manager & worker-manager containers available in more then one registry in case of issues with your chosen registry supplier (or self hosted one).
restoring in case of a complete disaster is simply a matter of recreating all the components using the installing method described above and populating your MongoDB with the most recent backup of the mongo database.

# Nebula components

Nebula is composed of the following components:

* MongoDB - the database layer, the manager stays is the only component that needs to access the backend DB.
* manager - this is the endpoint that manages Nebula, it updates the DB with any changes and is the endpoint where the workers query for any device_group\app changes.
* worker - this is the container that manages worker nodes, it makes sures to keep all app in sync with the required configuration by checking in every (configruable) X seconds with the manager and updating it's status accordingly.

Optionally you will also want to add the following if your use case is a massive scale web facing cluster in the same VPC\DC, not usually needed for a distributed system deployment:

* A server layer load balancer - ELB works well for this, it job is to direct traffic between all worker nodes
* A container layer load balancer - the recommended method is to create a nebula app with HAProxy\Nginx that will bind to the host network (not bridge) and will load balance requests to all containers on 127.0.0.1:containers_port

# How to install

The basic steps to getting Nebula to work is:

1. Create MongoDB, preferably a cluster & even a sharded cluster for large enough cluster
2. Create a database for Nebula on MongoDB & a user with read&write permissions for the api-manger, for example:

        use nebula
        db.createUser(
           {
             user: "nebula",
             pwd: "password",
             roles: [ "readWrite" ]
           }
        )
        
3. Create your copy of the manager docker image, a base image is available at [docker-hub](https://hub.docker.com/r/nebulaorchestrator/manager/) with the "manager" tag (example: `docker pull nebulaorchestrator/manager`), either use it as a baseline FROM to create your own image or mount your own config file to replace the default one or use envvars to config it, consulate the [config](config.md) for reference on the configuration values needed (and optional).
4. Create manager servers and have them run the manager container, make sure to open the manager ports on everything along the way & it's recommended having the restart=always flag set, preferably 2 at least load balanced between them for example:
 `/usr/bin/docker run -d -p 80:80 --restart=always --name nebula-manager <your_api_manager_container>`
5. Create your copy of the worker docker image, a base image is available at docker hub at [docker-hub](https://hub.docker.com/r/nebulaorchestrator/worker/) with the "worker" tag (example: `docker pull nebulaorchestrator/worker`), either use it as a baseline FROM to create your own image or mount your own config file to replace the default one or use envvars to config it, consulate the [config](config.md) for reference on the configuration values needed (and optional).
6. Create the worker servers and have them run the worker container, make sure to bind the docker socket & having the restart=always flag set is mandatory as nebula worker relies on containers restarts to reconnect to rabbit in case of long durations of it being unable to connect to rabbit in order to ensure latest app config is set correctly, the container needs to run with an APP_NAME envvvar:
 `/usr/bin/docker run -d --restart=always -e DEVICE_GROUP="example-device-group" --name nebula-worker -v /var/run/docker.sock:/var/run/docker.sock <your_worker_manager_container>`
    * note that to make things easier a sample RancherOS [cloud-config](https://github.com/nebula-orchestrator/docs/blob/master/examples/rancheros/cloud-config) is provided, just change every variable marked inside <> and start a new server with it.
7. If used for a web based service & not an IoT deployment create the haproxy\lb on each worker server, the recommended method is to have it containerized and managed from inside nebula as another nebula app (possibly not needed for services not accepting outside requests or for small scale where just the outside LB will do), attached is an [example-config](https://github.com/nebula-orchestrator/nebula/blob/master/docs/haproxy.cfg).
8. If used for a web based service & not an IoT deployment create either an external LB\ELB to route traffic between the worker servers or route53\DNS LB between the servers.
9. Create the apps using the nebula API.
10. create the device_group with the same name as the one you gave the workers "DEVICE_GROUP" envvar and have it include the apps you created.


# ARM version

Both the API & the workers have an ARM64v8 version auto deployed to Docker Hub tagged as follows:

 * latest ARM version is tagged arm64v8
 * each numbered version ARM build larger then 1.4.0 has a tag with the version number that is suffixed with "-arm64v8"
 
Other ARM versions are not currently auto built.
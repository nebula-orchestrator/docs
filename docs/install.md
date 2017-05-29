# Nebula components

Nebula is composed of the following components:

* MongoDB - the database layer, each app managed by Nebula is it's own document stored in mongo, when a new worker node first connects to the nebula cluster it requests the apps it is configured to manage (via the APP_NAME envvar tag) directly from mongo then disconnects from mongo, this is the only time the worker nodes connect to mongo, unlike the api-manager which stays connected to mongo 24/7.
* RabbitMQ - the messaging queue layer, each worker node managed by Nebula creates it's own queue per app it manages, each app also has it's own fanout exchange, every change made to any Nebula app is transferred to all relevant worker nodes via Rabbit immediately. 
* api-manager - this is the endpoint that manages Nebula, it updates the DB with any changes & publishes said changes to all relevent worker nodes by RabbitMQ.
* worker-manager - this is the container that manages worker nodes, it receives a list of tags (via the APP_NAME envvar tag in csv format) & makes sures to keep all said apps in sync with the required configuration. 

optionally you will also want to add the following:

* a server layer load balancer - ELB works well for this, it job is to direct traffic between all worker nodes
* a container layer load balancer - the recommended method is to create a nebula app with HAProxy\Nginx that will bind to the host network (not bridge) and will load balance requests to all containers on 127.0.0.1:<containers_port>

# How to install

the basic steps to getting Nebula to work is:

1. create mongo, preferably a cluster & even a sharded cluster for large enough cluster
2. create RabbitMQ, preferably a cluster with HA queues between them or even federated nodes for a large enough cluster
3. create your copy of the api-manger docker image, a base image is available at [docker-hub](https://hub.docker.com/r/nebulaorchestrator/api/) with the "api-manager" tag (example: `docker pull nebulaorchestrator/nebula:api-manager`), either use it as a baseline FROM to create your own image or mount your own config file to replace the default one
4. create api servers and have them run the api-manager container, make sure to open the api-manager ports on everything along the way & it's recommended having the restart=always flag set, preferably 2 at least load balanced between them for example:
 `/usr/bin/docker run -d -p 80:80 --restart=always --name nebula-api-manager <your_api_manager_container>`
5. create your copy of the worker-manger docker image, a base image is available at docker hub at [docker-hub](https://hub.docker.com/r/nebulaorchestrator/worker/) with the "worker-manager" tag (example: `docker pull nebulaorchestrator/nebula:worker-manager`), either use it as a baseline FROM to create your own image or mount your own config file to replace the default one
6. create the worker servers and have them run the worker-manager container, make sure to bind the docker socket & having the restart=always flag set is mandatory as nebula worker-manager relies on containers restarts to reconnect to rabbit in case of long durations of it being unable to connect to rabbit in order to ensure latest app config is set correctly, the container needs to run with an APP_NAME envvvar:
 `/usr/bin/docker run -d --restart=always -e APP_NAME="example-app,example-app-load-balancer,example-app-logg-aggregator" --name nebula-worker-manager -v /var/run/docker.sock:/var/run/docker.sock <your_worker_manager_container>`
7. create the haproxy\lb on each worker server, the recommended method is to have it containerized and managed from inside nebula as another nebula app (possibly not needed for services not accepting outside requests or for small scale where just the outside LB will do), attached is an [example-config](https://github.com/nebula-orchestrator/nebula/blob/master/docs/haproxy.cfg).
8. create either an external LB\ELB to route traffic between the worker servers or route53\DNS LB between the servers.
9. create the apps using the nebula API using the same APP_NAME as those you passed to the worker-manager
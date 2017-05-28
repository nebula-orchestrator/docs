***Nebula***

**Notices**
1. This is an opensource project, see attached license for more details.
2. The project is still rather young but that said it's already in use in a production environment at [vidazoo](https://www.vidazoo.com/) (Nebula was originally developed as an internal tool for vidazoo) for about a year in a multi cloud, multi region, high traffic (10 million+ requests/minute) environment with great success.
3. Help is very much welcomed.
4. tested OS: CoreOS, RancherOS, Ubuntu server 14.04 & 16.04, CentOS 6 & 7, Amazon linux, expected to work with any Docker compatible Linux distro.
5. tested Docker versions: 11.x up to 17.03.1-ce.

a API readme with examples,a basic diagram & comparision to popular orchestrators is available under the docs folder inside the [github](https://github.com/nebula-orchestrator/nebula) repo.

**Description**

this repo is designed to store all code for our custom built massive scale container management system, this is achieved by following the linux method of doing one thing only, each component is designed to be able to scale out for as far as needed, only downside over standard container orchestrator is that this loads the same "pod" of containers on each server that is managed with the same APP_NAME list rather then dynamically mix and match different apps, so it can also be viewed\used like a great CI\CD for docker which allows deploying to thousands of servers simultaneously using a single API call.

allows to:
1. change ports
2. change envvars
3. stop\start\restart\rolling restart containers
4. force pull updated containers
5. change # of containers running per core
6. change image used
7. manage multiple apps over different worker servers, each server "pod" of apps is determined by what APP_NAME envvar value comma seperated list you start the worker-manager container with, allowing you to mix and match for diffrent worker clusters while still managing all of them from the same api-manager containers.

there are 2 custom created services:
1. api manager - a REST API endpoint to control nebula, fully stateless (all data stored in DB only).
2. worker manager - a container which listens to rabbit and manages the worker server it runs on, one has to run on each worker, fully stateless.

as each worker server is in charge only of it's own containers all pulls from rabbit and work happens on the same time on all servers so pushing 50 million containers on a million servers will take the same amount of time as pushing 50 containers on 1 server.

**Example use cases**

1. apps with resource and\or traffic requirements so massive other orchestrators can't handle (thousands of servers and\or tens or even hundreds of millions of requests)
2. managing apps that spans multiple regions and\or clouds from a single source with a single API call
3. IOT\client deployments - a rather inventive use case which can allow you to deploy a new version to all of your clients (even if they range in the thousands) appliances with a single API call in minutes
4. SAAS providers - if you have a cluster per client (as you provide them with managed "private" instances) or such Nebula allows you to push new versions all your clients managed instances at once
5. a form of docker configuration management, similar to docker-compose only it also pushes changes in configurations to all managed servers.

**Installing**

the basic steps to getting Nebula to work is:
1. create mongo, preferably a cluster & even a sharded cluster for large enough cluster
2. create RabbitMQ, preferably a cluster with HA queues between them or even federated nodes for a large enough cluster
3. create your copy of the api-manger docker image, a base image is available at [docker-hub](https://hub.docker.com/r/nebulaorchestrator/nebula/) with the "api-manager" tag (example: `docker pull nebulaorchestrator/nebula:api-manager`), either use it as a baseline FROM to create your own image or mount your own config file to replace the default one
4. create api servers and have them run the api-manager container, make sure to open the api-manager ports on everything along the way & it's recommended having the restart=always flag set, preferably 2 at least load balanced between them for example:
 `/usr/bin/docker run -d -p 80:80 --restart=always --name nebula-api-manager <your_api_manager_container>`
5. create your copy of the worker-manger docker image, a base image is available at docker hub at [docker-hub](https://hub.docker.com/r/nebulaorchestrator/nebula/) with the "worker-manager" tag (example: `docker pull nebulaorchestrator/nebula:worker-manager`), either use it as a baseline FROM to create your own image or mount your own config file to replace the default one
6. create the worker servers and have them run the worker-manager container, make sure to bind the docker socket & having the restart=always flag set is mandatory as nebula worker-manager relies on containers restarts to reconnect to rabbit in case of long durations of it being unable to connect to rabbit in order to ensure latest app config is set correctly, the container needs to run with an APP_NAME envvvar:
 `/usr/bin/docker run -d --restart=always -e APP_NAME="example-app,example-app-load-balancer,example-app-logg-aggregator" --name nebula-worker-manager -v /var/run/docker.sock:/var/run/docker.sock <your_worker_manager_container>`
7. create the haproxy\lb on each worker server, the recommended method is to have it containerized and managed from inside nebula as another nebula app (possibly not needed for services not accepting outside requests or for small scale where just the outside LB will do), attached is an [example-config](https://github.com/nebula-orchestrator/nebula/blob/master/docs/haproxy.cfg).
8. create either an external LB\ELB to route traffic between the worker servers or route53\DNS LB between the servers.
9. create the apps using the nebula API using the same APP_NAME as those you passed to the worker-manager

**configuring**

configuring can be done either via envvars or via replacing the attached conf.json to one with your own variables, more info about possible config variables can be found at [config.md](https://github.com/nebula-orchestrator/nebula/blob/master/docs/config.md/)

**backup & restore**

as the only stateful part of the entire design is the MongoDB backing up mongo using any of the best practice methods available to it, is sufficient, that being said it might be a good idea to also have your version of the api-manager & worker-manager containers available in more then one registry in case of issues with your chosen registry supplier (or self hosted one).
restoring in case of a complete disaster is simply a matter of recreating all the components using the installing method described above and populating your MongoDB with the most recent backup of the mongo database.

**Repo folder structure**

* api-manager - the api endpoint through which Nebula is controlled, includes api-manager Dockerfile & entire code structure
* docs - misc docs (schematics, wishlist\todo's, and API doc)
* scripts - some helper scripts such as a jenkins script to deploy new versions upon build
* worker-manager - the worker manager that manages individual Nebula workers, includes worker-manager Dockerfile & entire code structure

**example architecture**

attached are 2 example for you to draw inspiration from when designing yours:

![example nebula architecture](https://github.com/nebula-orchestrator/nebula/blob/master/docs/cloudcraft%20-%20nebula.png "example nebula architecture")



![example nebula architecture](https://github.com/nebula-orchestrator/nebula/blob/master/docs/nebula.png "example nebula architecture")
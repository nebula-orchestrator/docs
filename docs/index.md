***Welcome to Nebula Documentation***

# Description

Nebula is a massive scale container management system, this is achieved by following the linux method of doing one thing only, each component is designed to be able to scale out for as far as needed, only downside over standard container orchestrator is that this loads the same "pod" of containers on each server that is managed with the same APP_NAME list rather then dynamically mix and match different apps, so it can also be viewed\used like a great CI\CD (or even as puppet for docker hosts) for docker which allows deploying to thousands of servers simultaneously using a single API call.

Allows to:

1. Change ports
2. Change envvars
3. Stop\start\restart\rolling restart containers
4. Force pull updated containers
5. Change # of containers running per core
6. Change image used
7. Manage multiple apps over different worker servers, each server "pod" of apps is determined by what APP_NAME envvar value comma seperated list you start the worker-manager container with, allowing you to mix and match for diffrent worker clusters while still managing all of them from the same api-manager containers.

There are 2 custom created services:

1. api manager - a REST API endpoint to control nebula, fully stateless (all data stored in DB only).
2. worker manager - a container which listens to rabbit and manages the worker server it runs on, one has to run on each worker, fully stateless.

As each worker server is in charge only of it's own containers all pulls from rabbit and work happens on the same time on all servers so pushing 50 million containers on a million servers will take the same amount of time as pushing 50 containers on 1 server.

# Example use cases

1. Apps with resource and\or traffic requirements so massive other orchestrators can't handle (thousands of servers and\or tens or even hundreds of millions of requests)
2. Managing apps that spans multiple regions and\or clouds from a single source with a single API call
3. IOT\client deployments - a rather inventive use case which can allow you to deploy a new version to all of your clients (even if they range in the thousands) appliances with a single API call in minutes
4. SAAS providers - if you have a cluster per client (as you provide them with managed "private" instances) or such Nebula allows you to push new versions all your clients managed instances at once
5. A form of docker configuration management, similar to docker-compose only it also pushes changes in configurations to all managed servers.

# Repo folder structure

* [api-manager](https://github.com/nebula-orchestrator/worker-manager) - the api endpoint through which Nebula is controlled, includes api-manager Dockerfile & entire code structure
* [docs](https://github.com/nebula-orchestrator/docs) - docs (schematics, wishlist\todo's, and API doc)
* [worker-manager](https://github.com/nebula-orchestrator/api-manager) - the worker manager that manages individual Nebula workers, includes worker-manager Dockerfile & entire code structure
* [nebula-python-sdk](https://github.com/nebula-orchestrator/nebula-python-sdk) - a pythonic SDK for using Nebula

# docker hub repos

* [api-manager](https://hub.docker.com/r/nebulaorchestrator/api/) - prebuilt docker image of the api-manager
* [worker-manager](https://hub.docker.com/r/nebulaorchestrator/worker/) - prebuilt docker image of the worker-manager

# Notices

 1. This is an open source project, see attached license for more details.
 2. The project is still rather young but that been said it's already in use in a production environment at [vidazoo](https://www.vidazoo.com/) (Nebula was originally developed as an internal tool for vidazoo) for about a year in a multi cloud, multi region, high traffic (10 million+ requests/minute) environment with great success.
 3. Help is very much welcomed.
 4. Tested OS: CoreOS, RancherOS, Ubuntu server 14.04 & 16.04, CentOS 6 & 7, Amazon linux, expected to work with any Docker compatible Linux distro.
 5. Tested Docker versions: 11.x up to 17.03.1-ce.

# example architecture

Attached are 2 example for you to draw inspiration from when designing yours:

![example nebula architecture](cloudcraft%20-%20nebula.png "example nebula architecture")



![example nebula architecture](nebula.png "example nebula architecture")
***Welcome to Nebula Documentation***

# Description

Nebula is a open source project created for Docker orchestration and designed to manage massive clusters at scale, it achieves this by scaling each project component out as far as required.
The project’s aim is to act as Docker orchestrator for IoT devices as well as for distributed services such as CDN or edge computing. 
Nebula is capable of simultaneously updating tens of thousands of IoT devices worldwide with a single API call in an effort to help devs and ops treat IoT devices just like distributed Dockerized apps.

Among other things Nebula allows to:

1. Change ports
2. Change envvars
3. Stop\start\restart\rolling restart containers
4. Force pull updated containers
5. Change # of containers running per core/instance
6. Change image used
7. Manage multiple apps over different worker servers, each server "pod" of apps is determined by what APP_NAME envvar value comma separated list you start the worker-manager container with, allowing you to mix and match for different worker clusters while still managing all of them from the same api-manager containers.
8. Mount volumes
9. Set containers with privileged permissions
10. Mount devices 
11. Control containers network affiliation

There are 2 custom created services:

1. api manager - a REST API endpoint to control nebula, fully stateless (all data stored in DB only).
2. worker manager - a container which listens to rabbit and manages the worker server it runs on, one has to run on each worker, fully stateless.

As each worker server is in charge only of it's own containers all pulls from rabbit and work happens on the same time on all servers so pushing 50 million containers on a million servers will take roughly the same amount of time as pushing 50 containers on 1 server.

# Example use cases

1. Apps with resource and\or traffic requirements so massive other orchestrators can't handle (thousands of servers and\or tens or even hundreds of millions of requests per minute)
2. Managing apps that spans multiple regions and\or clouds from a single source with a single API call
3. IOT\POS\client deployments - a rather inventive use case which can allow you to deploy a new version to all of your clients (even if they range in the thousands) appliances with a single API call in minutes
4. SAAS providers - if you have a cluster per client (as you provide them with managed "private" instances) or such Nebula allows you to push new versions all your clients managed instances at once
5. A form of docker configuration management, think of it as a cross between Docker-Compose to Puppet\Chef only it also pushes changes in configurations to all managed servers.

# Repo folder structure

* [api-manager](https://github.com/nebula-orchestrator/worker-manager) - the api endpoint through which Nebula is controlled, includes api-manager Dockerfile & entire code structure
* [docs](https://github.com/nebula-orchestrator/docs) - docs (schematics, wishlist\todo's, and API doc)
* [worker-manager](https://github.com/nebula-orchestrator/api-manager) - the worker manager that manages individual Nebula workers, includes worker-manager Dockerfile & entire code structure
* [nebula-python-sdk](https://github.com/nebula-orchestrator/nebula-python-sdk) - a pythonic SDK for using Nebula
* [nebula-cmd](https://github.com/nebula-orchestrator/nebula-cmd) - a CLI for using Nebula

# docker hub repos

* [api-manager](https://hub.docker.com/r/nebulaorchestrator/api/) - prebuilt docker image of the api-manager
* [worker-manager](https://hub.docker.com/r/nebulaorchestrator/worker/) - prebuilt docker image of the worker-manager

# Notices

 1. This is an open source project, see attached license for more details.
 2. The project is still rather young but that been said it's already in use in a production environment at [vidazoo](https://www.vidazoo.com/) (Nebula was originally developed as an internal tool for vidazoo before being open sourced) for over a year in a multi cloud, multi region, high traffic (10 million+ requests/minute) environment with great success.
 3. Help is very much welcomed.
 4. Tested OS: CoreOS, RancherOS, Ubuntu server 14.04 & 16.04, CentOS 6 & 7, Amazon linux, expected to work with any Docker compatible Linux distro.
 5. Tested Docker versions: each Nebula version is tested on the latest Docker version at the time of it's release but any Docker version that has support for user networks should work with Nebula.

# Example architecture

Attached are 3 example for you to draw inspiration from when designing yours, a more detailed explaination of it can be found at the [architecture](architecture.md) page:

![example nebula architecture](cloudcraft%20-%20nebula%20-%20IoT.png "example nebula architecture")


![example nebula architecture](cloudcraft%20-%20nebula.png "example nebula architecture")


![example nebula architecture](nebula.png "example nebula architecture")

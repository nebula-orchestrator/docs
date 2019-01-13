***Welcome to Nebula Documentation***

![Nebula-logo](pictures/logos/nebula-logo.png "Nebula-logo")

# Description

[Nebula](https://nebula-orchestrator.github.io) is a open source project created for Docker orchestration and designed to manage massive clusters at scale, it achieves this by scaling each project component out as far as required.
The project’s aim is to act as Docker orchestrator for IoT devices as well as for distributed services such as CDN or edge computing. 
Nebula is capable of simultaneously updating tens of thousands of IoT devices worldwide with a single API call in an effort to help devs and ops treat IoT devices just like distributed Dockerized apps.

Among other things Nebula allows to:

1. Change ports.
2. Change envvars.
3. Stop\start\restart\rolling restart containers.
4. Force pull updated containers.
5. Change # of containers running per core/instance.
6. Change image used.
7. Manage multiple apps over different worker servers, each server "device_group" can have an unlimited amount of apps added\removed from it which will then be picked up by all devices that are part of that "device_group".
8. Mount volumes.
9. Set containers with privileged permissions.
10. Mount devices .
11. Control containers network affiliation.
12. Auto integrate with Dockerfile healthchecks to restart unhealthy containers.

There are 2 custom created services:

1. manager - a REST API endpoint to control nebula, fully stateless (all data stored in DB only).
2. worker - a container which periodically checks in with the manager and manages the worker server it runs on, one has to run on each worker, fully stateless.

Due to clever use of TTL based [memoization](https://en.wikipedia.org/wiki/Memoization) it's possible to manage millions of devices with a single Nebula cluster without overloading the backend DB (or having it ridiculously large) & due to Kafka inspired monotonic ID you can rest easy knowing that the managed devices will always match the most recent configuration.

# Example use cases

1. Apps with resource and\or traffic requirements so massive other orchestrators can't handle (thousands of servers and\or tens or even hundreds of millions of requests per minute)
2. Managing apps that spans multiple regions and\or clouds from a single source with a single API call
3. IOT\POS\client deployments - a rather inventive use case which can allow you to deploy a new version to all of your clients (even if they range in the thousands) appliances with a single API call in minutes
4. SAAS providers - if you have a cluster per client (as you provide them with managed "private" instances) or such Nebula allows you to push new versions all your clients managed instances at once
5. A form of docker configuration management, think of it as a cross between Docker-Compose to Puppet\Chef only it also pushes changes in configurations to all managed servers.

# Repo folder structure

* [manager](https://github.com/nebula-orchestrator/manager) - the api endpoint through which Nebula is controlled, includes manager Dockerfile & entire code structure
* [docs](https://github.com/nebula-orchestrator/docs) - docs (schematics, wishlist\todo's, and API doc)
* [worker](https://github.com/nebula-orchestrator/worker) - the worker manager that manages individual Nebula workers, includes worker Dockerfile & entire code structure
* [nebula-python-sdk](https://github.com/nebula-orchestrator/nebula-python-sdk) - a pythonic SDK for using Nebula
* [nebula-cmd](https://github.com/nebula-orchestrator/nebula-cmd) - a CLI for using Nebula
* [nebula-orchestrator.github.io](https://github.com/nebula-orchestrator/nebula-orchestrator.github.io/issues) - the Jekyll based main website

# docker hub repos

* [manager](https://hub.docker.com/r/nebulaorchestrator/manager/) - prebuilt docker image of the manager
* [worker](https://hub.docker.com/r/nebulaorchestrator/worker/) - prebuilt docker image of the worker

# Notices

 1. This is an open source project, see attached license for more details.
 2. While still being a young project Nebula is already seeing production use at multiple companies across a variety of industries.
 3. Help is very much welcomed.
 4. Tested OS: CoreOS, RancherOS, Ubuntu server 14.04 & 16.04, CentOS 6 & 7, Amazon linux, expected to work with any Docker compatible Linux distro.
 5. Tested Docker versions: each Nebula version is tested on the latest Docker version at the time of it's release but any Docker version that has support for user networks should work with Nebula.

# Example architecture

Attached are 2 example for you to draw inspiration from when designing yours, a more detailed explanation of it can be found at the [architecture](architecture.md) page:

![example nebula architecture](pictures/cloudcraft%20-%20nebula%20-%20IoT.png "example nebula architecture")


![example nebula architecture](pictures/cloudcraft%20-%20nebula.png "example nebula architecture")

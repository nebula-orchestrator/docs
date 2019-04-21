# Internal design of Nebula

This is an advanced explanation on the logic behind using Nebula and how it ensures consistent application deployments at scale, You can safely skip this part of the guide if all you care about is deploying & using Nebula without knowing how it works, this part of the guide also assumes some knowledge of MongoDB.

## Motivation

Nebula is Designed to allow orchestration & deployments of Containers to distributed systems (IoT deployments being a good example of a distributed system but also CDN, POS, etc...), this comes with several limitations which prevents the use of standard orchestration solutions:

 * Each app\service has to be bound to the specific hardware.
 * Network can't be counted on (latency, disconnects).
 * Scaling should be (virtually) unlimited.
 
## Persistence

Nebula gracefully handle service crashes without losing any data do to it's reliance on production tested system to handle all data storage (MongoDB) & having all custom services (API & worker) being stateless by design.

 * MongoDB - MongoDB sharding should be enabled to ensure Persistence as long as the majority of the cluster is up.
 * workers - designed to fail hard & upon restart the workers follow a flow of pulling the latest config of their device_group & then starting to periodaclly check in with the managers for any changes, a Kafka inspired monotonic ID is attached to each change (app_id, device_group_id & prune_id) which ensures consistency in the changes & provides an addional protection against rolls back due to network delays returning a stale response.
 * managers - the managers syncs in periodically with the MongoDB backend regarding the device_group /info endpoint (the only one the deivces check in with) and stores them in a short term (default 10 seconds) memoize cache, this avoids overloading the backend MongoDB even with millions of devices, all other endpoints (that are typically only accessed for admin tasks) always immediately sync in with the backend DB, the monotonic ID's in use also provide assurance that only the latest change will be the one cached and synced to the devices despite the fact that each manager has it's own decentralized memoized cache.

## Backend DB selection

Currently the only implemented Backend DB is MongoDB, the reason for it being the first implemented DB being the ease at which JSON can be changed while still providing the ability to scale out as needed.
Future improvements will likely include the ability to use MariaDB & ETCD as other types of Backend DB.

## Scaling up vs Scaling out

There are usually 2 way of scaling services, scaling up (getting bigger\faster machines) & scaling out (getting more machines), Nebula is firmly in the "scaling out" camp, the reason for that is simply do to having possible limitations of scaling up (there's a limit to how many CPU cores you can stick in a single server) there is no limit to how much you can scale out (you can always buy more machines), by design nebula ensures that each component of it can be scaled out independently from each other (making each component a micro-service in it's own rights).

## Push vs Pull

Nebula is a pull based system, each worker periodically checks in with the master and pull the latest configuration which it then compares to it's existing local config & should any monotonic ID differ it will sync it's status to match the one received from the manager , this eliminates the need of keeping a list of worker addresses up to date in a centralized location & allows a much simpler way of adding\removing workers.

## Load Balancing

In larger deployments there will likely be multiple of each component, each component can be load balanced:

 * MongoDB mongos acts as a load balancer for the MongoDB backend, load balancing between multiple mongos is possible using standard HTTP LB.
 * API managers - being a standard HTTP service the can be load balanced using standard HTTP LB, HTTPS stripping on the LB level is both possible and recommended.

## Fail hard vs Fail soft
Nebula is fail hard, this means that on any error which isn't trivial (trivial being an error which can't affect consistency or future requests in any way) it will drop the entire service (both in the API managers & in the workers, depending on where the problem is), it is therefore necessary to ensure that both will always be restarted upon failure, in Docker engine this is achieved by having the `--restart` flag set to `unless-stopped`, the fail hard deign is a lot safer then fail soft as it removes risk of improper error handling.
 
## The API managers

The managers provide 2 essential services, the first is being the RESTful API endpoint through which Nebula is managed, they do so by serving an HTTP rest interface, HTTP REST was chosen do to it being used by virtually any programming language in the world, SDK (for instance the Python SDK) simply provide a bridge to Nebula API & CLI tools are in turn built using those SDK.
on top of this first essential service the manager also provide a special RESTful endpoint which is memoized and return the entire config a device needs to sync in with the latest state of a device_group, this endpoint is cached short and is contacted by the devices to sync with the latest version often.

## The workers

Each worker follows the same basic steps:

 1. At start contact the manager and get the needed config of a device that's part of it's configurable "device_group"
 2. start all apps that are set to run on devices that are part of the "device_group" it's on
 3. start another thread which checks the healthcheck configured in any app Dockerfile and restarts that container as needed
 4. periodically (defined by the "nebula_manager_check_in_time" in param and by default every 30 seconds) check in with the manager and get the latest config
    1. if any monotonic ID of the response received from the manager is larger then the one stored in the local configuration change the local configuration to match it
        1. if an app_id is larger update the app as needed (stop\start\restart\update\etc)
        2. if a device_group_id is larger update the apps by either starting the added app or removing a removed app from the device_group
        3. if the prune_id is larger then run pruning of docker images
    2. if any changes happened in the previous step save the newer configuration to the local config

## Cron jobs

Each worker run also controls running cron_jobs containers, this allows for simple periodic jobs (such as disk cleaning) to take place without the needs for a container running non stop and hugging resources, the cron_jobs are scheduled with each worker check_in so there might be a delay of "nebula_manager_check_in_time" at most after the scheduled job time to it's actual time run.
## The optional reporting system

The optional reporter system is Kafka based, this is really a classic use-case for Kafka, where a lot of devices each send a single report every X seconds with it's current state configuration, the flow for the reporting system goes from the workers to the Kafka, from there a "reporter" component populates the backend DB with the data which the manager instances can in turn query to retrieve to the admin the state of managed devices.
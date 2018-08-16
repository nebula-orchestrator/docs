# Internal design of Nebula

This is an advanced explanation on the logic behind using Nebula and how it ensures consistent application deployments at scale, You can safely skip this part of the guide if all you care about is deploying & using Nebula without knowing how it works, this part of the guide also assumes some knowledge of RabbitMQ & MongoDB.

## Motivation

Nebula is Designed to allow orchestration & deployments of Containers to distributed systems (IoT deployments being a good example of a distrubuted system but CDN, POS, etc... also counts), this comes with several limitations which prevents the use of standard orchestration solutions:

 * Each app\service has to be bound to the specific hardware.
 * Network can't be counted on (latency, disconnects)
 * Scaling should be (virtually) unlimited
 
## Persistence

Nebula gracefully handle service crashes without losing any data do to it's reliance on production tested system to handle all communications (RabbitMQ) and data storage (MongoDB) & having all custom services (API & worker) being stateless by design.

 * RabbitMQ - The default configuration of storing queue data on disk allows RabbitMQ to recover data from crashes, in a clustered setting queues should be replicated with an uneven (3,5,7...) number of nodes & `cluster_partition_handling` being set to `pause_minority`, this configuration ensures that so long as the majority of the RabbitMQ cluster is up Persistence is gurrenteed & that if more then half of the RabbitMQ servers goes down no more requests will be routed by the cluster.
 * MongoDB - Similarly to RabbitMQ MongoDB sharding should be enabled to ensure Persistence as long as the majority of the cluster is up.
 * workers - designed to fail hard & upon restart the workers follow a flow of creating a new RabbitMQ queue & attaching the queue to the appropriate RabbitMQ exchange, they then proceed to get the latest configuration from the API via RabbitMQ direct_reply_to & only after that the workers start processing the messages from the queue, while it may seems strange at first this order of the boot process ensures that even while the initial sync takes place any changes made via the API will be caught the workers.
 * API managers - the API managers immidiatly push any message to RabbitMQ\MongoDB rather then cache them internally & only proceed after reciving their confirmation (blocking process), this means that once you receive a reply from the API you can be sure that the change was accepted in will persist.

## Backend DB selection

Currently the only implemented Backend DB is MongoDB, the reason for it being the first implemented DB being the ease at which JSON can be changed & while still providing the ability to scale out as needed.
Future improvements will likely include the ability to use MariaDB & ETCD as other types of Backend DB.

## Scaling up vs Scaling out

There are usually 2 way of scaling services, scaling up (getting bigger\faster machines) & scaling out (getting more machines), Nebula is firmly in the "scaling out" camp, the reason for that is simply do to having possible limitations of scaling up (there's a limit to how many CPU cores you can stick in a single server) there is no limit to how much you can scale out (you can always buy more machines), by design nebula ensures that each component of it can be scaled out independently from each other (making each component a micro-service in it's own rights).

## Queue VS HTTP requests

While being more complex & adding additional requirements having a message queue allows for a couple of features which combined act as the backbone of Nebula design, the first being a "fanout" exchange, a central point which ensures sending the message recieved by rabbit to all workers queues of each app, a process which with HTTP would have considerably more complex (and thus error prone), the 2nd is that having a queue ensures that all commands to the workers are processed in the correct order, thus ensuring proper consistency of each worker configuration. 

## Push vs Pull

On the workers side Nebula is a pull based system, each worker creates it's own queue at RabbitMQ and pulls messages from it one at a time, this eliminates the need of keeping a list of worker addresses up to date in a centralized location & allows each worker to work at it's own pace catching up.
On the API side Nebula is a push based system, the only parts where the massages are pushed to is the RabbitMQ exchange & the Backend DB, both of which are located at a well known location for the API managers, 

## Load Balancing

In larger deployments there will likely be multiple of each component, each component can be load balanced:

 * RabbitMQ load balances to the server which hosts the queues internally, it's also possible to have an TCP LB in front of it to distrabute load between RabbitMQ nodes (AWS NLB, HAProxy, etc...).
 * MongoDB mongos acts as a load balancer for the MongoDB backend, load balancing between multiple mongos is possible using standard HTTP LB.
 * API managers - being a standard HTTP service the can be load balanced using standard HTTP LB.

## Fail hard vs Fail soft
Nebula is fail hard, this means that on any error which isn't trivial (trivial being an error which can't affect consistency or future requests in any way) it will drop the entire service (both in the API managers & in the workers, depending on where the problem is), it is therefore necessery to ensure that both will always be restarted upon failure, in Docker engine this is achevied by having the `--restart` flag set to `unless-stopped`, the fail hard deign is a lot safer then fail soft as it removes risk of improper error handling.
 
## The API managers

The API managers provide 2 essential services, each running in it's own thread, the first is being the endpoint through which Nebula is managed, they do so by serving an HTTP rest interface, HTTP REST was chosen do to it being used by virtually any programming language in the world, SDK (for instance the Python SDK) simply provide a bridge to Nebula API & CLI tools are in turn built using those SDK.
The 2nd service the API managers provide is that they respond to initial sync requests from the workers via RabbitMQ direct_reply_to with the latest config of the requested app, direct_reply_to was chosen as it's built into RabbitMQ thus removing the need from having another system accessible from the workers.

## The workers

Each worker follows the same basic steps:

 1. At start get a list of the apps needs to run on the worker device (via the `APP_NAME` envvar csv list)
 2. Open a thread per each app, at each thread it does the following:
    1. Open a connection to RabbitMQ, this is how the worker will receive app configuration updates.
    2. Create a RabbitMQ on said connection (if it doesn't exist already).
    3. Open another connection to rabbit and use a direct_reply_to to the API managers queue to get the current app configuration.
    4. Remove & clean the RabbitMQ intial sync connection.
    4. Start processing messages from the worker RabbitMQ queue.

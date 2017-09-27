# Common Nebula architecture designs

While there are too many possible ways to design Nebula architecture to list them all the following 2 designs will help cover common use cases as well as serve as a stepping stone to help explain the diffrent components of Nebula:

## IoT deployment
![example nebula architecture](cloudcraft%20-%20nebula%20-%20IoT.png "example nebula architecture")

In the above deployment example Nebula manages a distributed set of identical IoT devices, each devices configured with the same set of containers (identical APP_NAME=app1,app2... in all of them), every time a new devices is turned on it follows this steps:

1. The IoT device connects to RabbitMQ and create a new queue on it, Nebula maintains a per app per device queue in order to ensure correct order and matching status on all devices, the queue is configured to receive messages from a fanout exchange of said app (each Nebula app has a fanout exchange created at the time the app configuration is originally created). 
2. The IoT device pulls the latest app config from MongoDB & makes the required changes so that it matches that status, it then disconnects from MongoDB (read only)
3. From this point on the IoT device listens to any changes in the rabbit queues of it's apps and updates it's current config to match the latest config whenever there is a change.

Now if an admin wishes to deploy a new version or change any setting (envvar, mount, etc...) on all devices he simply has to follow this steps:

1. Push a new container version with a new tag to the configured Docker registry.
2. Update the control api (api-manager) by using the CLI\SDK\API with the latest app config that uses the new version tag as it's docker_image value, from here on Nebula will take care of the rest.
    1. Nebula api-manager will update the MongoDB backend with the new config.
    2. Nebula api-manager will also send a message to all currently active IoT devices which include said app in the APP_NAME config via their RabbitMQ queues (which in turns happens via an RabbitMQ fanout exchange)
    3. All the relevant IoT devices process their queues simultaneously (unless you configured max_restart_wait_in_seconds with a value different from 0) and replace their containers with the new version.

It's worth mentioning the follow:

* Both MongoDB & RabbitMQ needs to be accessible from both the Control API & from all of the IoT devices - it will work perfectly even through the Internet and will tolerate disconnects with no issues, the Nebula workers will simply start processing whatever messages got sent to it's RabbitMQ queue in that time.
* Disconnects of longer then 5 minutes will result in the Nebula worker-manager container killing itself in order for it to be restarted via Docker engine `--restart=always` flag, Nebula will then procedd to treat the IoT device as a new device and will follow the steps described above to get it in sync with the rest of the cluster.
* MongoDB is only used by the IoT devices in a read only mode and is only used once in their boot process.
* The control API is never accessed by the IoT devices.
* Each part of the system can scale out - MongoDB can be sharded and replicated, RabbitMQ can be both be clustered and federated, the api layer is stateless so can be increased as needed and there is no limit for the amount of workers as long as you make sure to scale out the other components to handle it.

## Large scale app deployment
![example nebula architecture](cloudcraft%20-%20nebula.png "example nebula architecture")

The following design uses nebula to manage thousands of webservers for a very large scale webapp, while the entire flow described in the IoT deployment above is also correct for this design it expends on it in the following ways:

* Rather then being distributed all apps are in the same VPC\DC
* In front of all of those thousands of workers there is an LB layer which distributes requests among all of the servers
* Each server consists of an internal LB (which is in itself an Nebula app) which routes the requests arriving to that server between the webapp containers runnning on it
* Each server has multiple webapp containers to better utilize all of it resources which are all the same Nebula app (for example the `containers_per` config has the value of `{"cpu": 2}` which will each server will have 2 webapp containers per CPU core)

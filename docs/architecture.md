# Common Nebula architecture designs

While there are too many possible ways to design Nebula architecture to list them all the following 2 designs will help cover common use cases as well as serve as a stepping stone to help explain the different components of Nebula:

## IoT deployment

![example nebula architecture](../pictures/cloudcraft%20-%20nebula%20-%20IoT.png "example nebula architecture")

In the above deployment example Nebula manages a distributed set of identical IoT devices, each devices configured with to be part of the same "device_group", every time a new devices is turned on it follows this steps:

1. The IoT device connects to the manager.
2. The IoT device pulls the latest device_group config.
3. From this point on the IoT device periodically (configured with the "nebula_manager_check_in_time") checks with the worker for any changes, due to memoization techniques in use the managers have a built in short term cache (configured with the "cache_time") and due to Kafka inspired monotonic ID's for field it's safe to use memoization without worrying about having stale configurations.

Now if an admin wishes to deploy a new version or change any setting (envvar, mount, etc...) on all devices he simply has to follow this steps:

1. Push a new container version with a new tag to the configured Docker registry.
2. Update the control api (manager) by using the CLI\SDK\API with the latest app config that uses the new version tag as it's docker_image value, from here on Nebula will take care of the rest by doing the following:
    1. Nebula manager will update the MongoDB backend with the new config.
    2. after the configurable "cache_time" expires (10 seconds by default) all the managers will contact MongoDB and receive the updated config.
    3. All the relevant IoT devices will receive the updated config and match their device status to the needed config.

It's worth mentioning the follow:

* MongoDB needs to be accessible only from the managers, not the workers - it will work perfectly even when using the Internet rather then LAN and will tolerate disconnects with no issues, due to monotonic ID's in use the workers will simply sync up to the latest needed configuration upon the network reconnects.
* Nebula is fail hard, Nebula worker container issues will result with it killing itself in order for it to be restarted via Docker engine `--restart=always` flag, Nebula will then proceed to treat the IoT device as a new device and will follow the steps described above to get it in sync with the rest of the cluster.
* Each part of the system can scale out - MongoDB can be sharded and replicated, the managers are stateless so can be increased as needed and there is no limit for the amount of workers as long as you make sure to scale out the other components to handle it.
* Nebula ensures consistency among all workers as long as the backend MongoDB is consistent, if for some reason you get a split brain in either or any other form or consistency issues Nebula cannot guarantee consistency so make sure to follow best practice in both to avoid those risks from happening.
* Nebula is eventually consistent, all workers will sync to the latest config but it might take up to "nebula_manager_check_in_time" + "device_group" seconds (40 seconds by default) for that to happen

## Large scale webapp deployment

![example nebula architecture](../pictures/cloudcraft%20-%20nebula.png "example nebula architecture")

The following design uses nebula to manage thousands of webservers for a very large scale webapp, while the entire flow described in the IoT deployment above is also correct for this design it expends on it in the following ways:

* Rather then being distributed all apps are in the same VPC\DC
* In front of all of those thousands of workers there is an LB layer which distributes requests among all of the servers, depending on your preference it can be an ELB\HAProxy\Nginx, DNS level LB, floating IP or any other LB method.
* Each server consists of an internal LB (which is in itself an Nebula app) which routes the requests arriving to that server between the webapp containers running on it
* Each server has multiple webapp containers to better utilize all of it resources which are all the same Nebula app (for example the `containers_per` config has the value of `{"cpu": 2}` which will then ensure each server will have 2 webapp containers per CPU core)

# Scaling considerations

Nebula was designed so that each component can scale out, below are some things to consider when designing your architecture.

* There are no special configuration needed to scale out\up the manager or the worker, you simply add more as needed.
* The manager is fully stateless, the recommended way to running it is inside a docker container on more then 1 server (for redundancy) with either a floating IP between them or behind a load balancer, requests to the API are made when a change is pushed (by admin\user or CI\CD tool) & it's also used for the workers sync, as such the required size & number of managers is depended on your frequency nebula managed devices check in with the master, keep in mind that a single manager can handle hundreds of devices due to effective memoization cache.
* There is only a need for 1 worker per worker node as each worker can handle an unlimited amount of apps as part of the device_group, there is no hard limit on the amount of worker nodes you can manage with nebula provided you make sure to scale the other Nebula components to handle the required load.
* Unless using for small scale it's recommended to increase the # of open files allowed on your managers to avoid the risk of running out of open connections.
* MongoDB should be clustered with the data being replicated multiple times for large scales, preferring to read from secondaries(slaves) will greatly increase performance ,sharding is possible but it's a lot less of an issue as each app config is rather small on it's own.
* Don't forget to consider how your going to scale out your routing layer, a load-balancer can get saturated just like a web app can.
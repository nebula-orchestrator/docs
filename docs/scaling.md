# Scaling considerations

Nebula was designed so that each component can scale out, below are some things to consider when designing your architecture.

* There are no special configuration needed to scale out\up the manager or the worker, you simply add more as needed.
* The manager is fully stateless, the recommended way to running it is inside a docker container on more then 1 server (for redundancy) with either a floating IP between them or behind a load balancer, requests to the API are made when a change is pushed (by admin\user or CI\CD tool) & it's also used for the workers sync, as such the required size & number of managers is depended on your frequency nebula managed devices check in with the master, keep in mind that a single manager can handle hundreds of devices due to effective memoization cache.
* There is only a need for 1 worker per worker node as each worker can handle an unlimited amount of apps as part of the device_group, there is no hard limit on the amount of worker nodes you can manage with nebula provided you make sure to scale the other Nebula components to handle the required load.
* Unless using for small scale it's recommended to increase the # of open files allowed on your managers to avoid the risk of running out of open connections.
* MongoDB should be clustered with the data being replicated multiple times for large scales, preferring to read from secondaries(slaves) will greatly increase performance ,sharding is possible but it's a lot less of an issue as each app config is rather small on it's own.
* Don't forget to consider how your going to scale out your routing layer, a load-balancer can get saturated just like a web app can.
* the scale needed is determined by both the amount of workers you have and the frequency where they check in with the managers, if you have a device_group where you don't mind updates taking a bit longer it might be easier (not to mention cheaper) to increase the check in frequency rather then adding more managers.

# Stress test results

Using Siege a single manager has been stress tested against the device_group /info endpoint, due to it being the only endpoint a device checks in with this provide a good estimate to the performance of a single manager under heavy load, here are the results of 500 concurrent connections each repeating the request 100 times with no delay between them:

```bash
Transactions:                  50000 hits
Availability:                 100.00 %
Elapsed time:                  64.24 secs
Data transferred:              20.12 MB
Response time:                  0.36 secs
Transaction rate:             778.33 trans/sec
Throughput:                     0.31 MB/sec
Concurrency:                  281.08
Successful transactions:       50000
Failed transactions:               0
Longest transaction:           12.54
Shortest transaction:           0.00
```

This test results shows that a single manager can handle any of the following:

* 466800 device checking in every 600 seconds with a 10 seconds cache
* 46680 device checking in every 60 seconds with a 10 seconds cache
* 23340 device checking in every 30 seconds with a 10 seconds cache
* 7780 device checking in every 10 seconds with a 10 seconds cache

Keep in mind that this is for a single manager, a Nebula cluster can scale the amount of managers out with near liner scalability so if you have a million devices you would still only need 22 manager containers to have them all kept in sync every minute (or you can use just 3 if you don't mind waiting 10 minutes for changes to catch on all devices).

It should also be mentioned that Siege CPU usage was the limiting factor for this test which likely means that each manager can potentially handle a much larger number of requests\second but this provide a good rule of thumb for any number crunching needs.

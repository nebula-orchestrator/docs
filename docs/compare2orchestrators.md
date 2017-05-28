|  | Nebula | Mesos+Marathon\DC/OS | Kubernetes | Swarm |
|-------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------|
| Stateless masters | yes | yes | yes | no - data stored in local master raft consensus  |
| worker nodes Scale limit | tens of thousands  | tens of thousands | 1000-5000 depending on version | unknown |
| containers Scale limit | millions | millions | 120000 | unknown |
| Health-check limits | unlimited - uses docker builtin health checks | depending on check type - https://mesosphere.com/blog/2017/01/05/introducing-mesos-native-health-checks-apache-mesos-part-1/ | unknown | unlimited - uses docker builtin health checks |
| Multi region\DC workers | yes | possible but not recommended according to latest DC/OS docs | possible via multiple clusters controlled via an ubernetes cluster | yes |
| Multi region\DC masters | yes - each master is only contacted when an API call is made | possible but extremely not recommended according to latest DC/OS docs | not possible - even with ubernetes each region masters only manage it's own regions | possible but not recommended do to raft consensus  |
| Designed for huge scales | yes | yes | if you consider 1000-5000 instances huge | unknown |
| Full REST API | yes | yes | yes | partial - by default no outside endpoint is available  |
| Self healing | yes | yes | yes | yes |
| Simple worker scaling up & down | yes | yes | yes | partial - scaling down cleanly requires an api call rather then just shutting down the server like the rest |
| CLI | WIP | yes | yes | yes |
| GUI | WIP | yes | yes | no |
| Load Balancing | yes- supports bringing your own HAProxy\Nginx\etc in a 2 step process (the first between instances & the 2nd between containers on that instance) | yes - HTTP only for outside connections - marathon-lb, supports bringing your own otherwise | yes | yes - auto routes inside the cluster but you still need to LB between cluster nodes from the outside  |
| Simple masters scaling up & down | yes - master is fully stateless | no | no | partial - simple as long as quorum remains in the process |
| Simple containers scaling up & down | yes - single api call and\or adding\removing worker nodes | yes - single api call | yes - single api call | yes - single api call |
| Modular design (or plugin support) | yes - every parts does 1 thing only | yes - 2 step orchestrator | yes | yes |
| Backend DB's | Mongo & RabbitMQ | zookeeper | etcd | internal in masters |
| multiple apps share worker node | yes | yes | yes | yes |
| dynamic allocation of work containers | no | yes | yes | yes |
| Changes processing time scalability | extremely short, each worker is unaffected from the rest | longish - must wait for an offer matching it requirements first which at complex clusters can take a bit | short - listens to EtcD for changes which is fast but the masters don't scale when the load does | longish - gossip protocol will get there in the end but might take the scenic route |
| Type of containers supported | docker with possible future extension | docker, mesos universal container | docker with possible future extension | docker only |
| Key trade-offs | allows scales of Mesos with full health checks with very rapid deployments\changes while being unlimited to a single region\DC while being stable at the cost of not allowing multiple apps sharing the same worker node & having lots of moving parts | battle proven orchestrator that's damn near impossible to break at the cost of speed of changes & sticking to a single zone (for clusters with requests counts smaller then a million in a single region this is an amazing solution) | the buzzword choice, very popular (so support & updates are great) but kinda forces you to do things the Google way & not nearly as scalable as some other choices | comes prebuilt with the docker engine so easy to set up but is kinda of a black box, also using GOSSIP only ensures eventual consistency so who knows when a requested change takes affect |
| Recommended deployment method | run a docker container of it | complex and varies depending on your design | complex and varies depending on your design | prebuilt in docker engine so just a couple of commands |

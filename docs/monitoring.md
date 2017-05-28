### what to monitor?

it's best to monitor the following components:
* Mongo - following mongo best practices
* RabbitMQ = following RabbitMQ best practices
* docker service - on all hosts
* docker api-manager container - check that the api-manager container is running
* docker api-manager - a API endpoint for monitoring the status is available at `/api/status`, consult the [api](https://github.com/naorlivne/nebula/blob/master/docs/api.md) docs for more info 
* docker api-worker container - check that the api-manager container is running on all worker nodes
* (optional) routing layers - changes depanding on your design
* app containers - check that the app containers are running on your worker nodes
* end2end network connections - if your app accepts HTTP\TCP\UDP requests best to check e2e connectivity as well

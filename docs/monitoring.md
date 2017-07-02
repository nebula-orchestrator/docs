### What to monitor?

It's best to monitor the following components:

* Mongo - following mongo best practices
* RabbitMQ - following RabbitMQ best practices
* Docker service - on all hosts
* Docker api-manager container - check that the api-manager container is running
* Docker api-manager - a API endpoint for monitoring the status is available at `/api/status`, consult the [api](https://github.com/naorlivne/docs/blob/master/docs/api.md) docs for more info 
* Docker api-worker container - check that the api-manager container is running on all worker nodes
* (Optional) routing layers - changes depending on your design
* App containers - check that the app containers are running on your worker nodes
* End2End network connections - if your app accepts HTTP\TCP\UDP requests best to check e2e connectivity as well

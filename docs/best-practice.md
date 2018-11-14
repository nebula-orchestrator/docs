### What to monitor?

It's best to monitor the following components:

* MongoDB - following MongoDB best practices.
* RabbitMQ - following RabbitMQ best practices.
* Docker service - on all hosts.
* Docker api-manager container - check that the api-manager container is running.
* Docker api-manager - a API endpoint for monitoring the status is available at `/api/status`, consult the [api](https://github.com/naorlivne/docs/blob/master/docs/api.md) docs for more info.
* Docker api-worker container - check that the api-manager container is running on all worker nodes.
* (Optional) routing layers - changes depending on your design.
* App containers - check that the app containers are running on your worker nodes - if your Dockerfile has healthcheck configure Nebula will automatically restart containers marked as "unhealthy".
* End2End network connections - if your app accepts HTTP\TCP\UDP requests best to check e2e connectivity as well.

Another helpful tip is that it's possible to know the status of a deployment to the worker nodes by checking their RabbitMQ queue, as each worker only ACK a message after it completed deploying it a queue will only be empty of messages if the worker have processed all changes & is matching the required configuration for that app.

### Securing Nebula

In production environments it's important to keep the following in mind in order to provide the best security practices 

* Strong passwords (8+ chars made of combination of upper case, lower case, numbers & special characters) should be used in the API layer, MongoDB & RabbitMQ
* The API layer support HTTPS stripping on the LB layer in front of it, it's recommended to use that configuration.
* MongoDB also supports SSL, which is stored on a remote location should be considered to be used.
* The API layer is also used for administration connections and as such it can be used in a private VPC\DC even if the workers are remote, only the RabbitMQ must be accessible to all workers.
* Using the latest version of Nebula is always recommended, vunrlabilites in packages are always discovered & patched on a routine manner.
* The API logs by default write each request to the API including the IP which originated the request.
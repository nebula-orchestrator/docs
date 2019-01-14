### What to monitor?

It's best to monitor the following components:

* MongoDB - following MongoDB best practices.
* Docker service - on all hosts.
* Docker manager container - check that the manager container is running.
* Docker manager - a API endpoint for monitoring the status is available at `/api/status`, consult the [api](https://github.com/naorlivne/docs/blob/master/docs/api.md) docs for more info.
* Docker worker container - check that the worker container is running on all worker nodes.
* (Optional) routing layers - changes depending on your design.
* App containers - check that the app containers are running on your worker nodes - adding a HEALTHCHECK configuration to the Dockerfile will make Nebula automatically restart containers marked as "unhealthy" and is therefor highly recommended.
* End2End network connections - if your app accepts HTTP\TCP\UDP requests best to check e2e connectivity as well.

### Securing Nebula

In production environments it's important to keep the following in mind in order to provide the best security practices 

* Strong passwords (8+ chars made of combination of upper case, lower case, numbers & special characters) should be used in the API layer & MongoDB.
* The manager support HTTPS stripping on the LB layer in front of it, it's recommended to use that configuration.
* MongoDB also supports SSL, which is stored on a remote location should be considered to be used.
* Only the manager (API layer) should be accessible to worker devices, the MongoDB backend should be accessabile only from the manager.
* Using the latest version of Nebula is always recommended, vunrlabilites in packages are always discovered & patched on a routine manner.
* The API logs by default write each request to the API including the IP which originated the request.
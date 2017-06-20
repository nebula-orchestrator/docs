# Hello World tutorial

```bash
docker exec -it mongo mongo
use admin
db.createUser(
   {
     user: "nebula",
     pwd: "nebula",
     roles: [ "readWrite" ]
   }
)
use nebula

```

exit the container (ctrl-d)

```bash
docker exec -it rabbit sh
rabbitmqctl add_vhost nebula
rabbitmqctl add_user nebula nebula
rabbitmqctl set_permissions -p nebula nebula ".*" ".*" ".*"

```

exit the container (ctrl-d)

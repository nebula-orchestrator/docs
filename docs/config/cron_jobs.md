## Configuring cron_jobs

The following table shows the config variables used to set individual cron_jobs inside nebula (via the API):

!!! tip
    The tables slides to to side for viewing it's full information (not clear do to the rtfd theme)

| field              | type                     | example value                                 | default value            | description                                                                                                                  |
|--------------------|--------------------------|-----------------------------------------------|--------------------------|------------------------------------------------------------------------------------------------------------------------------|
| env_vars           | dict                     | {"test": "test123"}                           | {}                       | a dict of envvars that will be passed to each work containers, use {} for non                                                |
| docker_image       | string                   | nginx                                         | none - must be declared  | what docker image to run                                                                                                     |
| running            | bool                     | true                                          | true                     | true - cron will be enabled, false - stops said cron                                                                         |
| volumes            | list                     | []                                            | []                       | what volumes to mount inside the containers ,follows docker run -v syntax of host_path:container_path:ro/rw, use [] for non  |
| devices            | list                     | []                                            | []                       | what devices to grant the containers access ,follows docker run --device of host_path:container_path:ro/rwm, use [] for non  |
| privileged         | bool                     | false                                         | false                    | true - cron gets privileged permissions, false - no privileged permissions                                                   |
| schedule           | string                   | 0 * * * *                                     | none - must be declared  | the schedule of the cron to run, follows standard linux cron schedule syntax                                                 |

[Drone](https://drone.io/) plugin for deploying to [nebula](http://nebula-orchestrator.github.io/) in a fully automated CI/CD fashion.

Note that this plugin is only in charge of the deploying to Nebula part of the CI/CD, other steps in the drone.io pipeline will likely be needed to build the container from the source code of your repo & deploy it to a Docker registry (as well as testing it) with this plugin likely being the final step of the deployment.

## Usage

This plugin can be used to deploy applications to a nebula server, it will create\update the given nebula tasks as needed.

The below pipeline configuration demonstrates simple usage:

!!! note 
    In addition to the `.drone.yml` file you will need to create a `nebula.json` file that contains the nebula configuration as well as the "app_name" (for app) or "cron_job_name" (for cron_job) field. Please see [here](https://github.com/nebula-orchestrator/drone-nebula/blob/master/test/test_files/nebula.json) for an example. 

```yaml
kind: pipeline
type: docker
name: default

steps:
- name: nebula_deploy
  image: nebulaorchestrator/drone-nebula
  settings:
    nebula_host: my-nebula-host.com
    nebula_job_file: nebula.json
```

### Value substitution

Example configuration with values substitution:

```yaml
kind: pipeline
type: docker
name: default

steps:
- name: nebula_deploy
  image: nebulaorchestrator/drone-nebula
  settings:
    nebula_host: my-nebula-host.com
    nebula_job_file: nebula.json
    my_image_tag: my_dynamic_image
```

In the nebula.json file (please note the $ before the PLUGIN_MY_IMAGE_TAG key):

```json
{
  ...
  "image": "myrepo/myimage:$PLUGIN_MY_IMAGE_TAG",
  ...
}
```

will result in:

```json
{
  ...
  "image": "myrepo/myimage:my_dynamic_image",
  ...
}
```

## Parameter Reference

| envvar          | description                                                                    | default value | required  |
|-----------------|--------------------------------------------------------------------------------|---------------|-----------|
| nebula_host     | The nebula server FQDN\IP                                                      |               | yes       |
| nebula_job_file | The nebula configuration file location relative to the root folder of the repo | "nebula.json" | no        |
| nebula_username | The nebula basic_auth username to use                                          | None          | no        |
| nebula_password | The nebula basic_auth password to use                                          | None          | no        |
| nebula_token    | The nebula token_auth token to use                                             | None          | no        |
| nebula_port     | The nebula server port                                                         | 80            | no        |
| nebula_protocol | The nebula server protocol                                                     | "http"        | no        |
| nebula_job_type | The type of nebula job, "app" or "cron_job"                                    | "app"         | no        |

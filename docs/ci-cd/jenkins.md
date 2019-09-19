The best way to deploy to [Nebula](http://nebula-orchestrator.github.io/) from Jenkins in a fully automated CI/CD fashion is to use the [Drone](https://drone.io/) plugin in it's container form (Drone plugins are basically containers).

Note that this plugin is only in charge of the deploying to Nebula part of the CI/CD, other steps in Jenkins will likely be needed to build the container from the source code of your repo & deploy it to a Docker registry (as well as testing it) with this plugin likely being the final step of the deployment.

## Usage

This plugin can be used to deploy applications to a nebula server, it will create\update the given nebula tasks as needed.

The below pipeline configuration demonstrates simple usage:

!!! note 
    In addition to the run command given below you will need to create a `nebula.json` file that contains the nebula configuration as well as the "app_name" (for app) or "cron_job_name" (for cron_job) field in your repo root. Please see [here](https://github.com/nebula-orchestrator/drone-nebula/blob/master/test/test_files/nebula.json) for an example. 

```bash
docker run -e PLUGIN_NEBULA_HOST=my-nebula-host.com -e PLUGIN_NEBULA_JOB_FILE=nebula.json -v $(pwd):/my_repo --workdir /my_repo nebulaorchestrator/drone-nebula

```

### Value substitution

Example configuration with values substitution:

```bash
docker run -e my_image_tag=my_dynamic_image -e PLUGIN_NEBULA_HOST=my-nebula-host.com -e PLUGIN_NEBULA_JOB_FILE=nebula.json -v $(pwd):/my_repo --workdir /my_repo nebulaorchestrator/drone-nebula

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

| envvar                 | description                                                                    | default value | required  |
|------------------------|--------------------------------------------------------------------------------|---------------|-----------|
| PLUGIN_NEBULA_HOST     | The nebula server FQDN\IP                                                      |               | yes       |
| PLUGIN_NEBULA_JOB_FILE | The nebula configuration file location relative to the root folder of the repo | "nebula.json" | no        |
| PLUGIN_nebula_USERNAME | The nebula basic_auth username to use                                          | None          | no        |
| PLUGIN_NEBULA_PASSWORD | The nebula basic_auth password to use                                          | None          | no        |
| PLUGIN_NEBULA_TOEKN    | The nebula token_auth token to use                                             | None          | no        |
| PLUGIN_NEBULA_PORT     | The nebula server port                                                         | 80            | no        |
| PLUGIN_NEBULA_PROTOCOL | The nebula server protocol                                                     | "http"        | no        |
| PLUGIN_NEBULA_JOB_TYPE | The type of nebula job, "app" or "cron_job"                                    | "app"         | no        |

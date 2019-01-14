# Nebula-Python-SDK
An SDK for managing [nebula](https://nebula-orchestrator.github.io/) via python.

translates all of Nebula [API](http://nebula.readthedocs.io/en/latest/api/) calls to something more pythonic.

Source code is available at [github](https://github.com/nebula-orchestrator/nebula-python-sdk)

# How To Use
first get NebulaPythonSDK onto your machine
```bash
# Install from PyPi
pip install NebulaPythonSDK
```

now use it in your code
```python
# Load API wrapper from library
from NebulaPythonSDK import Nebula

# Create API object.
# port defaults to 80, protocol defaults to "http" & request_timeout defaults to 60 if any of them is not set.
connection = Nebula(username="your_nebula_user", password="your_nebula_pass", host="nebula.example.com", port=80, protocol="http", request_timeout=60)

# List apps
app_list = connection.list_apps()

# List app info
app_config = connection.list_app_info("app_name")

# Create app
app_conf = {
    "containers_per_cpu": 8,
    "env_vars": {
        "test": "blabla",
        "test3t2t32": "tesg4ehgee"
    },
    "docker_ulimits": [],
    "networks": ["nebula"],
    "running": True,
    "rolling_restart": False,
    "volumes": ["/tmp:/tmp/1", "/var/tmp/:/var/tmp/1:ro"],
    "containers_per": {
        "cpu": 6
    },
    "starting_ports": [
        {
            "81": 80
        }
    ],
    "docker_image": "httpd",
    "privileged": False,
    "devices": []
}
connection.create_app("app_name", app_conf)

# create device group
device_group_config = {"apps": ["app_name"]}
connection.create_device_group("device_group_name", device_group_config)

# list device group
connection.list_device_group("device_group_name")

# list device group info
connection.list_device_group_info("device_group_name")

# ping api
connection.check_api()

# delete app
connection.delete_app("app_name")

# stop app
connection.stop_app("app_name")

# start app
connection.start_app("app_name")

# restart app
connection.restart_app("app_name")

# update app
connection.update_app("app_name", app_conf)

# prune images on all device groups
connection.prune_images()

# delete device_group
connection.delete_device_group("device_group_name")

# prune images on a selected device groups
connection.prune__device_group_images("device_group_name")

# update device group
connection.update_device_group("device_group_name", device_group_config)

```

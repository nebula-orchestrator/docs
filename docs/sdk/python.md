# Nebula-Python-SDK
An SDK for managing [nebula](http://nebula.readthedocs.io/en/latest/) via python.

Translates all of Nebula [API](http://nebula.readthedocs.io/en/latest/api/) calls to something more pythonic.

Source code is available at [github](https://github.com/nebula-orchestrator/nebula-python-sdk)

# How To Use

First install NebulaPythonSDK:
```bash
# install from PyPi
pip install NebulaPythonSDK
```

Now you can use it in your python conde:
```python
# Load API wrapper from library
from NebulaPythonSDK import Nebula

# Create API object.
connection = Nebula(username="your_nebula_user", password="your_nebula_pass", host="nebula.example.com", protocol="http")

# list apps
app_list = connection.list_apps()

# list app info
app_config = connection.list_app_info("app_name")

# create app
app_conf = {
    "containers_per_cpu": 8,
    "env_vars": {
        "test": "blabla",
        "test3t2t32": "tesg4ehgee"
    },
    "docker_ulimits": [],
    "network_mode": "bridge",
    "running": True,
    "containers_per": {
        "cpu": 6
    },
    "starting_ports": [
        {
            "81": 80
        }
    ],
    "docker_image": "httpd"
}
connection.create_app("app_name", app_conf)
```
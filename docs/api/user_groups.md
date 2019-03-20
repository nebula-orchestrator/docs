All of the user groups endpoints require an "admin" to edit\view.

# Update user_group
Updates a user_group

 **request**

```
PUT /api/v2/user_groups/<user_group_name>/update HTTP/1.1
Host: 127.0.0.1:5000
Content-Type: application/json
cache-control: no-cache
Authorization: Basic <your-basic_auth_base64-here>

{
    "group_members": ["test123"],
    "pruning_allowed": true,
    "apps": {"test": "rw", "test123": "ro"},
    "device_groups": {"test": "rw", "test123": "ro"},
    "admin": true
}
```

 **response example**

```
200
{
    "_id": {
        "$oid": "5c921a639d723e083d2a2fd5"
    },
    "user_group": "test_user_group",
    "group_members": [
        "test123"
    ],
    "pruning_allowed": true,
    "apps": {
        "test": "rw",
        "test123": "ro"
    },
    "device_groups": {
        "test": "rw",
        "test123": "ro"
    },
    "admin": true
}
```

# Create a user_group
Create a new user_group

 **request**

```
POST /api/v2/user_groups/<user_group_name> HTTP/1.1
Host: 127.0.0.1:5000
Content-Type: application/json
cache-control: no-cache
Authorization: Basic <your-basic_auth_base64-here>

{
    "group_members": ["test123"],
    "pruning_allowed": false,
    "apps": {"test": "rw", "test123": "ro"},
    "device_groups": {"test": "rw", "test123": "ro"},
    "admin": false
}
```

 **response example**

```
200
{
    "_id": {
        "$oid": "5c921a639d723e083d2a2fd5"
    },
    "user_group": "test_user_group",
    "group_members": [
        "test123"
    ],
    "pruning_allowed": true,
    "apps": {
        "test": "rw",
        "test123": "ro"
    },
    "device_groups": {
        "test": "rw",
        "test123": "ro"
    },
    "admin": true
}
```

When trying to add a existing user_group:

```
403
{
    "user_group_exists": true
}
```

# Delete a user_group 
Removes a user_group

 **request**

```
DELETE /api/v2/user_groups/<user_group_name> HTTP/1.1
Host: 127.0.0.1:5000
Content-Type: application/json
cache-control: no-cache
Authorization: Basic <your-basic_auth_base64-here>
```

 **response example**

```
200
{}
```

When trying to delete a non existing user_group:

```
403
{
    "user_group_exists": false
}
```

# List all user_groups
list all user_groups

 **request**

```
GET /api/v2/users HTTP/1.1
Host: 127.0.0.1:5000
Content-Type: application/json
cache-control: no-cache
Authorization: Basic <your-basic_auth_base64-here>
```

 **response example**

```
200
{
    "user_groups": [
        "test_user_group"
    ]
}
```

# List user_group info
list a user_group info

 **request**

```
GET /api/v2/user_groups/<user_group_name> HTTP/1.1
Host: 127.0.0.1:5000
Content-Type: application/json
cache-control: no-cache
Authorization: Basic <your-basic_auth_base64-here>
```

 **response example**

```
200
{
    "user_group": "test_user_group",
    "group_members": [
        "test123"
    ],
    "pruning_allowed": true,
    "apps": {
        "test": "rw",
        "test123": "ro"
    },
    "device_groups": {
        "test": "rw",
        "test123": "ro"
    },
    "admin": true
}
```

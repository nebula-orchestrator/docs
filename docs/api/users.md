# Update user
Updates a user password and\or token, note that the response of said fields is hashed.

 **request**

```
PUT /api/v2/users/<username>/update HTTP/1.1
Host: 127.0.0.1:5000
Content-Type: application/json
cache-control: no-cache
Authorization: Basic <your-basic_auth_base64-here>

{
	"password": "<your_new_pass>",
	"token": "<your_new_token>"
}
```

 **response example**

```
200
{
    "_id": {
        "$oid": "5c85134a9d723e4c9a7dd03c"
    },
    "user_name": "<username>",
    "password": "$2b$12$bKJRenSWB/XQrFYLNqKan.oWrPvGrgkd1Oy75nsWrn.tEj5RDdCq.",
    "token": "$2b$12$LOqP59o2z48.H4qPLldHxOfXHJtw3JqeY7R.DG4xEECd6kwdnJ8bm"
}
```

# Create a user
Create a new user, note that the response of said fields is hashed.

 **request**

```
POST /api/v2/users/<username> HTTP/1.1
Host: 127.0.0.1:5000
Content-Type: application/json
cache-control: no-cache
Authorization: Basic <your-basic_auth_base64-here>

{
	"password": "<your_new_pass>",
	"token": "<your_new_token>"
}
```

 **response example**

```
200
{
    "user_name": "<username>",
    "password": "$2b$12$XjZjbZivcPfJQbJMIPbv3Oh5OMhk.0IftkoaysxJvVJzo8k//.Ipi",
    "token": "$2b$12$BImGUFUk2fcXACipwEwGqumyZdmvfLLQfaKVvsjDn0iWCAQBBG106"
}
```

When trying to add a existing user:

```
403
{
    "user_exists": true
}
```

# Refresh a user token
Generate a new secure random token for a user and returns it.


!!! note
    This is the only time the token will be returned unhashed, make sure to keep it safe.


 **request**

```
POST /api/v2/users/<username>/refresh HTTP/1.1
Host: 127.0.0.1:5000
Content-Type: application/json
cache-control: no-cache
Authorization: Basic <your-basic_auth_base64-here>

{}
```

 **response example**

```
200
{
    "token": "v7s3agw1NXfkkUXz9WHMO_U1QS9xXs9ZEHoKETiNWQY"
}
```

# Delete a user 
Removes a user

 **request**

```
DELETE /api/v2/users/<username> HTTP/1.1
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

When trying to delete a non existing user:

```
403
{
    "user_exists": false
}
```

# List all users
list all users

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
    "users": [
        "test123"
    ]
}
```

# List user info
list a user info, not much info in it as everything is hashed but can show you if a user exists already

 **request**

```
GET /api/v2/users/<username> HTTP/1.1
Host: 127.0.0.1:5000
Content-Type: application/json
cache-control: no-cache
Authorization: Basic <your-basic_auth_base64-here>
```

 **response example**

```
200
{
    "user_name": "test123",
    "password": "$2b$12$bi7hX3cR43rLmqaT3o360eeU2F3VSm2i5dCG5WmvMz3jRgyHFo0Wu",
    "token": "$2b$12$BTq.s2QTO9TzV4MLoMRa1uX0dNbkjuiY05UeE5qyue.lgRYj.GSuW"
}
```

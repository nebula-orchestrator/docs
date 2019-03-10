# Authentication

There are currently 2 possible authentication methods:

 * Basic auth - pass the `Authorization: Basic <your-basic_auth_base64-here>` header to the API call
 * Bearer tokens - pass the `Authorization: Bearer <your-token-here>` header to the API call
 
 you can use either\both however you please, should you wish to disable both auth you must set the `auth_enabled` parameter on the manager to `false`.

# Get api status
a simple endpoint that can be used to monitor the API is working

 **request**

```
GET /api/v2/status HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-basic_auth_base64-here>
Content-Type: application/json
Cache-Control: no-cache
```

 **response example**

success
```
200
{
    "api_available": true
}
```

# Prune unused images on all device
Prune unused images on all devices

 **request**

```
POST /api/v2/prune HTTP/1.1
Host: localhost:5000
Authorization: Basic <your-basic_auth_base64-here>
Content-Type: application/json
Cache-Control: no-cache
```

 **response example**

```
202
{
    "prune_ids": {
        "test": 544,
        "test123": 222
    }
}
```

# List a filtered paginated view of the optional reports system
The optional reporting system reports can be queried from this endpoint in the manager.

Can be filtered via the request parameters (none are required):

 * page_size = the number of reports per page to show
 * hostname = an exact match to a hostname to filter by
 * device_group = an exact match to a device_group to filter by
 * report_creation_time = the value (in seconds since unix epoch) of time to filter by
 * report_creation_time_filter = the math expression to filter the report_creation_time by, defaults to eq (equal), one of:
    * eq 
    * gt 
    * lt 
    * gte 
    * lte 
    * ne
 * last_id = the last_id that is returned by the a current paginated query, passing it will make the load the next paginated page, upon reaching the last page 'null' will be returned.


 **request**

```
GET /api/v2/reports?page_size=3&amp; hostname=5c5b7ceae29a&amp; device_group=test&amp; report_creation_time_filter=gt&amp; report_creation_time=1551252013&amp; last_id=5c75489a209bde00015570e5 HTTP/1.1
Host: 127.0.0.1:5000
Authorization: Basic <your-basic_auth_base64-here>
Content-Type: application/json
cache-control: no-cache
```

 **response example**

```
200
{
    "data": [
        {
            ...very_long_paginated_view_of_3_reports...
        }
    ],
    "last_id": {
        "$oid": "5c75489a209bde00015570e8"
    }
}
```

## Configuring user_groups

The following table shows the config variables used to set individual user_groups inside nebula (via the API):

!!! tip
    The tables slides to to side for viewing it's full information (not clear do to the rtfd theme)

| field              | type                     | example value                                 | default value            | description                                                                                                                                |
|--------------------|--------------------------|-----------------------------------------------|--------------------------|--------------------------------------------------------------------------------------------------------------------------------------------|
| group_members      | list                     | ["test123"]                                   | []                       | a list of users that are a part of the group                                                                                               |
| pruning_allowed    | bool                     | false                                         | false                    | false - group members are not allowed to run prune commands, true - group members can run prune commands                                   |
| apps               | dict                     | {"test": "rw", "test123": "ro"}               | {}                       | a key\value dict of the name of the app and the permission level granted access to group members, ro - read only, rw - read\write          |
| cron_jobs          | dict                     | {"test": "rw", "test123": "ro"}               | {}                       | a key\value dict of the name of the cron_job and the permission level granted access to group members, ro - read only, rw - read\write     |
| device_groups      | dict                     | {"test": "rw", "test123": "ro"}               | {}                       | a key\value dict of the name of the device_group and the permission level granted access to group members, ro - read only, rw - read\write |
| admin              | bool                     | true                                          | false                    | false - group members are normal users, true - group members are admins that can run any command                                           |

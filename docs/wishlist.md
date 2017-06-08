The following is a wishlist of things that could be added\changed in nebula, this is a temporery list until a proper github workflow gets rolling:

1. Add multiple back-ends rather then just mongodb (etcd, mysql\maria, etc), also note in docs that maria is the recommended method (Maria multi-master write & all synced read slaves is perfect for Nebula flow)
2. Add volume\storage plugin usage for containers
3. Add network plugin usage for containers
4. Add memory and cpu limits for running containers
5. Add running containers log drivers
6. Add per container ulimits config
7. Add running containers as privileged option
8. Add the api monitor
9. Add option to set container run command 
10. Set the api manager status page to work without basic auth
11. Multiple users + permissions (read\write per app + admin permissions) - kong is a current workaround
12. Walkthrough tutorial of setting everything up + examples
13. Ability to PUT just a single part of an app while keeping the rest rather then having to POST everything from scratch
14. Registry auth from the usual docker config file as well as from optionally from nebula config
15. A CLI
16. Refactor to the newest version of docker-py (new syntax so require full refactor) - use the change to unuglify everything now that the design is proven to work.
17. Have the random wait time be on the app level rather then the cluster level & have the stop command be hardwired to have a wait time of 0
18. A web interface
19. Better file structure
20. Real logging
21. Multiple auth methods (AD/LDAP, OAuth, etc...)
22. A real website rather then just the git repo
23. Redo the wishlist to task list in the github builtin task board
24. Finish rolling restart module
25. Add mount folders\files support
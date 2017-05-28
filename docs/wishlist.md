1. add multiple back-ends rather then just mongodb (etcd, mysql\maria, etc), also note in docs that maria is the recommended method (Maria multi-master write & all synced read slaves is perfect for Nebula flow)
2. add volume\storage plugin usage for containers
3. add network plugin usage for containers
4. add memory and cpu limits for running containers
5. add running containers log drivers
6. add per container ulimits config
7. add running containers as privileged option
8. add the api monitor
9. add option to set container run command 
10. set the api manager status page to work without basic auth
11. multiple users + permissions (read\write per app + admin permissions) - kong is a current workaround
12. walkthrough tutorial of setting everything up + examples
13. ability to PUT just a single part of an app while keeping the rest rather then having to POST everything from scratch
14. registry auth from the usual docker config file as well as from optionally from nebula config
15. a CLI
16. refactor to the newest version of docker-py (new syntax so require full refactor) - use the change to unuglify everything now that the design is proven to work.
17. have the random wait time be on the app level rather then the cluster level & have the stop command be hardwired to have a wait time of 0
18. a web interface
19. better file structure
20. real logging
21. multiple auth methods (AD/LDAP, OAuth, etc...)
22. https://opencollective.com/ sponsorship & backers ecosystem?
23. a real website rather then just the git repo
24. move all the docs to mkdocs with readthedocs theme and store in it's own repo and on readthedocs.io
25. redo the wishlist to task list in the github builtin task board
26. finish rolling restart module
27. add mount folders\files support
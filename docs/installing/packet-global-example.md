# Nebula on Packet global deployment example

The [docker-compose tutorial](getting-started.md) is great for getting a feeling and doing local development on the Nebula API but as a repeated request has been to have a simple way to confirm Nebula global scalability a terrform module has been created which will do the following:

 - Install a MongoDB & Nebula manager on a single packet devices
 - Create multiple devices (by default 5) over multiple packet facilities (a list of 5 different facilities by default)
 - Create and configure an `example` app & device_group on Nebula

## Running instructions

 1. clone the repo
 2. cd into the repo folder
 3. Change the run.tf (in repo root folder) to your variables 
 4. run `terraform apply`.
 
You now have a nebula cluster that includes a single manager and as many workers you gave it (default 9) spread out across packet regions (default 9 regions).
 
## Requires: 

 - terraform 0.12.0 or higher
 - [PACKET_AUTH_TOKEN](https://www.terraform.io/docs/providers/packet/index.html) envvar set to your packet token
 - a packet organization
 - curl installed on the machine running terraform
 
## Configuration variables  :

 - server_size - the size of the Nebula manager server - defaults to `c1.small.x86`
 - server_region_device - the region where the nebula manager server will reside - defaults to `ams1`
 - worker_count - the number of Nebula workers to create - defaults to `5`
 - worker_region_device - the regions where the workers will be deployed on - defaults to `["ams1","dfw2","ewr1","nrt1","sjc1"]`
 - worker_size - the size of the servers used in Nebula - note that at least 1GB is needed as it uses a RancherOS for simplicity sake - defaults to `c1.small.x86`
 - PACKET_AUTH_TOKEN - the token used to connect to your packet account - needs to be declared as an envvar - required
 
 Should you want to ssh to the devices for any reason (not needed for the system to work) you can do so with the private key & the `root` user for the manager and `rancher` user for the workers.
 
## this can take 10-15 minutes for the manager to start as it has to install docker & docker-compose then download and run all containers, the initial boot of the workers is considerably faster but it might still be a couple of minutes after the terraform run completes.

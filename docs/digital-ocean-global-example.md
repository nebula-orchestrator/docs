# Nebula on Digital Ocean global deployment example

The [docker-compose tutorial](getting-started.md) is great for getting a feeling and doing local development on the Nebula API but as a repeated request has been to have a simple way to confirm Nebula global scalability a terrform module has been created which will do the following:

 - Install a MongoDB & Nebula manager on a single digital ocean droplet
 - Create multiple droplets (by default 9) over multiple digital ocean regions (a list of 9 different regions by default)
 - Create and configure an `example` app & device_group on Nebula
 
## Requirements: 

 - terraform 0.12.0 or higher
 - DIGITALOCEAN_TOKEN 
 - an ssh pub key pre uploaded to digital ocean
 - curl installed on the machine running terraform
 
 
## Configuration variables  :

 - server_size - the size of the Nebula manager server - defaults to `2gb`
 - server_region_droplet - the region where the nebula manager server will reside - defaults to `nyc3`
 - ssh_key_name - the public ssh key as given in digital ocean that will be attached to the droplets, requires a single name - required
 - worker_count - the number of Nebula workers to create - defaults to `9`
 - worker_region_droplet - the regions where the workers will be deployed on - defaults to `["nyc1", "nyc3", "sfo2", "ams3", "sgp1", "lon1", "fra1", "tor1", "blr1"]`
 - worker_size - the size of the servers used in Nebula - note that at least 1GB is needed as it uses a RancherOS for simplicity sake - defaults to `2gb`
 - digital_ocean_token - the token used to connect to your digital ocean account - required
 
Should you want to ssh to the droplets for any reason (not needed for the system to work) you can do so with the private key & the `centos` user for the manager and `rancher` user for the workers.
 
## Running instructions

 1. clone the repo from https://github.com/nebula-orchestrator/nebula-digitalocean-global-deployment-example
 2. cd into the repo folder
 3. Change the run.tf (in repo root folder) to your variables 
 4. run `terraform apply`.
 
## this can take 10-15 minutes for the manager to start as it has to install docker & docker-compose then download and run all containers, the initial boot of the workers is considerably faster but it might still be a couple of minutes after the terraform run completes.

Provision Mina node(s) on Digital Ocean droplets
===

## About
Provision mina block producer nodes declaratively on Digital Ocean using terraform and ansible.

## Prerequisites
To be able to provision nodes, you will need the following:
* `terraform` binary provided by `terraform` package.
* `ansible-playbook` binary provided by `ansible` package.
* Digital Ocean account with billing enabled.


## Table of contents
<!--ts-->
   * [Set-up](#set-up)
      * [Secrets](#secrets)
         * [DO token](#do-token)
         * [SSH keys](#generate-ssh-keys)
   * [Usage](#usage)
      * [STDIN](#stdin)
      * [Local files](#local-files)

<!--te-->
---
### Set-up
git clone this repository and `cd` to the root folder of it.
```bash
git clone git@github.com:simisimis/mina-node-on-do.git minanode
cd !!
```

#### Secrets
Following secrets will be needed:
* DO token
* SSH keys used to ssh/provision droplets
  - generate before provisioning
  - store SSH keys in `secrets` folder 
* Mina wallet private key passcode
  - typed in prompt during provisioning

#### DO token
In your DO web panel, go to `API` > `Generate New Token`
Store it for later use.

#### generate SSH keys
```bash
ssh-keygen -t rsa -b 2048 -f ./secrets/mina-do-ssh
```

* post ssh key to Digital Ocean
```bash
curl -X POST "https://api.digitalocean.com/v2/account/keys" -H "Authorization: Bearer $TF_VAR_do_token" -d '{"name":"mina-do-ssh", "public_key":"ssh-rsa ..."}'
```

* initialize terraform provider
```bash
terraform -chdir=terraform init
```

* create Digital Ocean droplet(vm)
```bash
terraform -chdir=terraform apply -auto-approve
```

* 
```bash
terraform -chdir=terraform show
```

* test ssh to created host
```bash
ssh root@178.62.202.131 -i secrets/id_rsa_DO_mina_node
```

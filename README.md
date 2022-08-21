Provision Mina node(s) on Digital Ocean droplets
===

## About
Provision mina block producer nodes declaratively on Digital Ocean using terraform and ansible.

## Prerequisites
To be able to provision nodes, you will need the following:
* `terraform` binary provided by `terraform` package.
* `ansible-playbook` binary provided by `ansible` package.
* Digital Ocean account with billing enabled.
* (Optional) [just](https://github.com/casey/just) to run project-specific commands easier. _See `Justfile`_

## Assumptions
_Assumption is the mother of all..._ But mentioning them in README makes them design choices.
The following were assumed:
* Users will create/copy their ssh key pair to `./secrets` folder and set key's name(not path) as `prv_key` value in `./terraform/terraform.tfvars`
* Users will name their public ssh key on Digital Ocean as `mina-do-ssh`.

---
TL;DR  
Follow 3 step Quick Start Guide. Or come back to TOC for details.

## Table of contents
<!--ts-->
   * [Quick Start Guide](#quick-start-guide)
   * [Set-up](#set-up)
      * [Secrets](#secrets)
         * [DO token](#do-token)
         * [SSH keys](#generate-ssh-keys)
         * [my-wallet passphrase](#my-wallet-passphrase)
   * [Tips and Observations](#tips-and-observations)

<!--te-->

---

### Quick Start Guide
1. Set needed variables in `terraform/terraform.tfvars` that are defined in `terraform/variables.tf`
2. Create Digital Ocean resources
```bash
# When running first time, run terraform init
terraform -chdir=terraform init

terraform -chdir=terraform apply -auto-approve
```
3. Provision mina node on created resources
```bash
ansible-playbook -i ansible/hosts --private-key=./secrets/id_rsa_DO_mina_node ./ansible/provision_nodes.yaml
```

---

### Set-up

git clone this repository and `cd` to the root folder of it.
```bash
git clone git@github.com:simisimis/mina-node-on-do.git minanode
cd !!
```
---
### Secrets
Following secrets will be needed:
* DO token
* SSH keys used to ssh/provision droplets
  - generate before provisioning
  - store SSH keys in `secrets` folder
  - add generated public key to DO.
* Mina wallet private key passcode
  - typed in prompt during provisioning
---

### DO token
In your DO web panel, go to `API` > `Generate New Token`
Store it for later use.

---

### generate SSH keys
Generate ssh key pair and place them in `secrets` folder:
```bash
ssh-keygen -t rsa -b 2048 -f ./secrets/id_rsa_DO_mina_node
```
Once keys are in `secrets` folder, add generated public key to DO. You can either add it through web, or use curl to POST it.  
_NOTE: terraform expects public ssh key on DO named - `mina-do-ssh`_
```bash
curl -X POST "https://api.digitalocean.com/v2/account/keys" -H "Authorization: Bearer <your DO token>" -d '{"name":"mina-do-ssh", "public_key":"<contents of ./secrets/id_rsa_DO_mina_node.pub>"}'
```

---

### `my-wallet` passphrase
By default, mina wallet key pair is created during ansible run. If you want to use existing wallet, set a full path in `./terraform/terraform.tfvars` assigned to `mina_wallet` variable.
Whether you chose to use your own wallet key pair, or create it during provisioning, you will be prompted to type your wallet passphrase during ansible run.

---

### Tips and Observations
* `mina` application will most likely crash when starting on a host that has less than 16GB of RAM. Make sure you use right plan for this.
* Digital Ocean droplet sizes can be retrieved with following curl GET command:
```
# use `jq` to parse json response
curl -X GET "https://api.digitalocean.com/v2/sizes" -H Authorization:\ Bearer\ <your DO token> |jq
```

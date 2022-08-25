Provisioning Mina node(s) on Digital Ocean droplets
===

## About
Provisioning mina block producer nodes on `mainnet/devnet` on Digital Ocean using terraform and ansible.

## Prerequisites
To be able to provision nodes, you will need the following:
* `terraform`
* `ansible`
* Digital Ocean account with billing enabled.
* (Optional) [just](https://github.com/casey/just) simplify repeatedly running project-specific commands. _See [Justfile](Justfile)_

## Assumptions
> Assumption is the mother of all... But mentioning them in the README makes them design choices.  

The following were assumed:
* Users will create/copy their ssh key pair to [./secrets](secrets) folder and set the key's name (not path) as `prv_key` value in [terraform.tfvars](terraform/terraform.tfvars_example). Default is `id_rsa_DO_mina_node`.
* Users will name their public ssh key on Digital Ocean as `mina-do-ssh`.

---

## Instructions

### Table of contents
* [Set-up](#set-up)
  * [Secrets](#secrets)
    * [DO token](#do-token)
    * [SSH keys](#generating-ssh-keys)
    * [my-wallet passphrase](#my-wallet-passphrase)
* [Provisioning](#provisioning)
* [Tips and Observations](#tips-and-observations)

---

### Set-up

git clone this repository and `cd` to the root folder of it.
```bash
git clone git@github.com:simisimis/mina-node-on-do.git minanode
cd minanode
```

#### Secrets

The following secrets are required:
* DO token
* SSH keys used to ssh/provision droplets
  - generate before provisioning
  - store SSH keys in `secrets` folder
  - add generated public key to DO and name it `mina-do-ssh`.
* Mina wallet private key passcode
  - typed in prompt during provisioning

##### DO token
In your DO web panel, go to `API` > `Generate New Token`. Store it for later use.

##### Generating SSH keys
Generate the ssh key pair and place it in the `secrets` folder:
```bash
ssh-keygen -t rsa -b 2048 -f ./secrets/id_rsa_DO_mina_node
```
Once the keys are in the `secrets` folder, add the generated public key to DO. You can either add it through web, or use `curl` to `POST` it.  
_NOTE: During terraform run it is expected that public ssh key on DO will be named `mina-do-ssh`_
```bash
curl -X POST "https://api.digitalocean.com/v2/account/keys" -H "Authorization: Bearer <your DO token>" -d '{"name":"mina-do-ssh", "public_key":"<contents of ./secrets/id_rsa_DO_mina_node.pub>"}'
```

##### `my-wallet` passphrase
By default, mina wallet key pair is created during ansible run. If you want to use existing wallet, set a full path in [terraform.tfvars](terraform/terraform.tfvars_example) assigned to `mina_wallet` variable.
Whether you chose to use your own wallet key pair, or create it during provisioning, you will be prompted to type your wallet passphrase during ansible run.

---

### Provisioning
1. Set needed variables in [terraform.tfvars](terraform/terraform.tfvars_example) that are defined in [variables.tf](terraform/variables.tf)
2. Create the Digital Ocean resources
```bash
# When running for the first time, run terraform init
terraform -chdir=terraform init

terraform -chdir=terraform apply -auto-approve
```
3. Provision mina node on created resources
```bash
ansible-playbook -i ./ansible/hosts --private-key=./secrets/id_rsa_DO_mina_node ./ansible/provision_nodes.yaml
```

After giving 5 minutes or so for the mina service to start, as a result you should have droplet(s) with mina block producer(s) running and listening on port 8302. You can ssh to the droplet(s) and inspect this with `ss -ntlp` command.


### Tips and Observations
* `mina` application will most likely crash when starting on a host that has less than 16GB of RAM. Make sure you use the right plan for this.
* Digital Ocean droplet sizes can be retrieved with the following curl `GET` command:
```
# use `jq` to parse the json response
curl -X GET "https://api.digitalocean.com/v2/sizes" -H Authorization:\ Bearer\ <your DO token> |jq
```

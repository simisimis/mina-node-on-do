# An attempt to automate mina node deployment to the cloud
* create TF_VAR_do_token on Digital Ocean

* generate ssh key
```bash
ssh-keygen -t rsa -b 2048 -f ./id_rsa_DO_mina_node
```

* post ssh key to Digital Ocean
```bash
curl -X POST "https://api.digitalocean.com/v2/account/keys" -H "Authorization: Bearer $TF_VAR_do_token" -d '{"name":"mina-do-ssh-pub", "public_key":"ssh-rsa ..."}'
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

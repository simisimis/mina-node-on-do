# create droplet with terraform
apply:
  terraform apply ./terraform/main.tf
# destroy Mina node droplet
destroy:
  terraform destroy

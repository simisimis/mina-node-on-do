# create droplet with terraform and prepare ansible
apply:
  terraform -chdir=terraform apply -auto-approve
# destroy Mina node droplet
destroy:
  terraform -chdir=terraform destroy -auto-approve

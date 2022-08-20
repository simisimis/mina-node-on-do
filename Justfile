# Create droplet with terraform and prepare ansible
apply:
  terraform -chdir=terraform apply -auto-approve
# Provision Mina node on created droplet(s)
playbook:
  ansible-playbook -i ansible/hosts --private-key=./secrets/id_rsa_DO_mina_node ansible/provision_nodes.yaml
# Destroy Mina node droplet(s)
destroy:
  terraform -chdir=terraform destroy -auto-approve
# If you just want to do the thing
up:
  just apply
  just playbook

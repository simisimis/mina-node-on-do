# Configure the DigitalOcean Provider
terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "mina-do-ssh" {
  name = "mina-do-ssh"
}

# Create a mina node droplet
resource "digitalocean_droplet" "mina-node" {
  count    = var.node_count
  image    = "ubuntu-18-04-x64"
  name     = "mina-node-${count.index}"
  region   = var.droplet_region
  size     = var.droplet_plan
  ssh_keys = [
    data.digitalocean_ssh_key.mina-do-ssh.id
  ]
  provisioner "remote-exec" {
    inline = ["sudo apt update", "sudo apt install python3 -y", "echo done installing python"]

    connection {
      host        = self.ipv4_address
      type        = "ssh"
      user        = "root"
      private_key = file("${path.cwd}/secrets/${var.prv_key}")
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u root -i '${self.ipv4_address},' --private-key ${path.cwd}/secrets/${var.prv_key} -e 'pub_key=\"${data.digitalocean_ssh_key.mina-do-ssh.public_key}\"' -e 'mina_user=${var.mina_user}' -e 'become_pass=${var.mina_user_pass}' -e 'mina_wallet=${var.mina_wallet}' ./ansible_init.yaml"
  }
}

resource "local_file" "ansible_inventory" {
  content     = templatefile("${path.module}/templates/ansible_inventory.tpl", { 
    nodes = digitalocean_droplet.mina-node.*.ipv4_address,
    mina_user = var.mina_user
    become_pass = var.mina_user_pass
  })
  filename    = "${path.cwd}/ansible/hosts"
}

output "droplet_ip_addresses" {
  value = {
    for droplet in digitalocean_droplet.mina-node:
    droplet.name => droplet.ipv4_address
  }
}

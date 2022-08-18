terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {}
variable "prv_key" {}
variable "pub_key" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "mina-do-ssh-pub" {
  name = "mina-do-ssh-pub"
}

# Create a mina node droplet
resource "digitalocean_droplet" "mina-node" {
  count    = 1
  image    = "ubuntu-18-04-x64"
  name     = "mina-node-${count.index}"
  region   = "ams3"
  size     = "s-2vcpu-2gb"
  ssh_keys = [
    data.digitalocean_ssh_key.mina-do-ssh-pub.id
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
    working_dir = path.cwd
    command = "ansible-playbook -u root -i '${self.ipv4_address},' --private-key ${path.cwd}/secrets/${var.prv_key} -e 'pub_key=${path.cwd}/secrets/${var.pub_key}' ./mina_ansible_init.yaml"
  }
}

output "droplet_ip_addresses" {
  value = {
    for droplet in digitalocean_droplet.mina-node:
    droplet.name => droplet.ipv4_address
  }
}

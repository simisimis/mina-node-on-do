terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

# Create a mina node droplet
resource "digitalocean_droplet" "mina-node" {
  image    = "ubuntu-18-04-x64"
  name     = "mina-node-1"
  region   = "ams3"
  size     = "s-2vcpu-2gb"
  ssh_keys = ["a6:2d:92:65:ed:d2:f4:08:7c:56:e5:4e:b5:d6:a0:cc"]
}

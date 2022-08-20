resource "digitalocean_firewall" "mina-node-fw" {
  name = "mina-node-fw"

  droplet_ids = concat(digitalocean_droplet.mina-node.*.id)

  inbound_rule {
    protocol                  = "tcp"
    port_range                = "22"
    source_addresses          = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol                  = "tcp"
    port_range                = "80"
    source_addresses          = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol                  = "tcp"
    port_range                = "443"
    source_addresses          = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol                  = "tcp"
    port_range                = "8302"
    source_addresses          = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol                  = "tcp"
    port_range                = "3085"
    source_addresses          = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol                  = "tcp"
    port_range                = "all"
    destination_addresses     = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol                  = "udp"
    port_range                = "all"
    destination_addresses     = ["0.0.0.0/0", "::/0"]
  }
}

variable "do_token" {
  description = "Digital Ocean peronal access token"
  sensitive = true
}
variable "prv_key" {
  description = "SSH private key to connect to terraform created resources"
}

variable "node_count" {
  description = "Number of instances terraform should create"
  default = 1
}

variable "droplet_region" {
  description = "Datacenter where your droplets should be created"
  default = "lon1"
}

variable "droplet_plan" {
  description = "Droplet plan/size"
  default = "s-2vcpu-2gb"
}

variable "ansible_user" {
  default = "mina"
}

variable "ansible_user_pass" {
  default = "openbook"
  sensitive = true
}

variable "mina_wallet" {
  description = "Path to your existing mina wallet"
}


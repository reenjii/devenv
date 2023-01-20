variable "sshkey" {
  type        = string
  description = "The path of the SSH public key that will be used to connect."
  # Example: "~/.ssh/id_rsa.pub"
}

variable "image_name" {
  type        = string
  description = "The name of the OpenStack image to use to create the Public Cloud instance."
  # Example: "Ubuntu 22.04"
}

variable "flavor_name" {
  type        = string
  description = "The name of the OpenStack flavor to use to create the Public Cloud instance."
  # Example: "b2-7"
}

# SSH key
resource "openstack_compute_keypair_v2" "laptop" {
  provider   = openstack
  name       = "laptop"
  public_key = file(var.sshkey)
}

# Security group
resource "openstack_compute_secgroup_v2" "secgroup_devenv" {
  name        = "secgroup_devenv"
  description = "security group for devenv"

  # Allow SSH on port 22 (host)
  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  # Allow SSH on port 4222 (devenv container)
  rule {
    from_port   = 4222
    to_port     = 4222
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  # Allow port 80 (devenv landing page)
  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  # Allow port range 10000-10010 to expose services
  rule {
    from_port   = 10000
    to_port     = 10010
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

# Create instance
resource "openstack_compute_instance_v2" "test_terraform_instance" {
  name        = "devenv"
  provider    = openstack
  image_name  = var.image_name
  flavor_name = var.flavor_name
  key_pair    = openstack_compute_keypair_v2.laptop.name
  security_groups = ["${openstack_compute_secgroup_v2.secgroup_devenv.name}"]
  user_data = "${file("devenv-user-data.sh")}"
  network {
    name      = "Ext-Net"
  }
}

# Output instance IP
output "instance_ip" {
  value = "${openstack_compute_instance_v2.test_terraform_instance.network.0.fixed_ip_v4}"
}
packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "adil2p6ami" {
  ami_name      = "adil2p6ami"
  source_ami    = "ami-0ada6d94f396377f2"
  instance_type = "t3a.small"
  region        = "us-east-2"
  ssh_username  = "ubuntu"

  tags = {
    Name = "adil2p6ami"
  }
}


build {
  sources = [
    "source.amazon-ebs.adil2p6ami"
  ]

  provisioner "shell" {
    script = "./install.sh"
  }
}

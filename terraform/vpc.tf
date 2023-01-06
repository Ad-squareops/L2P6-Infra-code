module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "testVPCAdi"
  cidr                 = "20.0.0.0/16"
  azs                  = ["us-east-2a", "us-east-2b"]
  private_subnets      = [cidrsubnet("20.0.0.0/16", 8, 0), cidrsubnet("20.0.0.0/16", 8, 1)]
  public_subnets       = [cidrsubnet("20.0.0.0/16", 8, 2), cidrsubnet("20.0.0.0/16", 8, 3)]
  private_subnet_names = ["Adi-Private-Subnet-One", "Adi-Private-Subnet-Two"]
  public_subnet_names  = ["Adi-Public-Subnet-One", "Adi-Public-Subnet-Two"]

  enable_nat_gateway = true
  single_nat_gateway = true
  vpc_tags = {
    Name      = "testVPCAdi"
    terraform = "true"
  }
}

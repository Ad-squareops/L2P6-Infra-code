resource "aws_instance" "s1" {
  ami                    = "ami-0ada6d94f396377f2"
  instance_type          = "t3a.small"
  availability_zone      = "us-east-2a"
  key_name               = "adikp1"
  security_groups        = [aws_security_group.adimongo.id]
  subnet_id              = element(module.vpc.private_subnets, 0)
  vpc_security_group_ids = [aws_security_group.adimongo.id]

  tags = {
    Name = "adi-mongo1"
  }
}

resource "aws_instance" "s2" {
  ami                    = "ami-0ada6d94f396377f2"
  instance_type          = "t3a.small"
  availability_zone      = "us-east-2a"
  key_name               = "adikp1"
  security_groups        = [aws_security_group.adimongo.id]
  subnet_id              = element(module.vpc.private_subnets, 0)
  vpc_security_group_ids = [aws_security_group.adimongo.id]

  tags = {
    Name = "adi-mongo2"
  }
}

resource "aws_instance" "s3" {
  ami                    = "ami-0ada6d94f396377f2"
  instance_type          = "t3a.small"
  availability_zone      = "us-east-2a"
  key_name               = "adikp1"
  security_groups        = [aws_security_group.adimongo.id]
  subnet_id              = element(module.vpc.private_subnets, 0)
  vpc_security_group_ids = [aws_security_group.adimongo.id]

  tags = {
    Name = "adi-mongo3"
  }
}

# Security Group
resource "aws_security_group" "adimongo" {
  name   = "adi-Mongo-SG"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "TCP"
    security_groups = [aws_security_group.pritunl-sg.id]
  }

  ingress {
    from_port = 27017
    to_port   = 27017
    protocol  = "TCP"
    self      = true
  }
    
  ingress {
    from_port       = 27017
    to_port         = 27017
    protocol        = "TCP"
    security_groups = [aws_security_group.asg-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "adi-Mongo-SG"
  }
}

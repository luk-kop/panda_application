resource "aws_instance" "panda" {
  count                  = length(var.availability_zones)
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  availability_zone      = var.availability_zones[count.index]
  key_name               = var.aws_key_name
  vpc_security_group_ids = [aws_security_group.sg-pub.id]
  subnet_id              = aws_subnet.pub_subnet[count.index].id

  tags = {
    Name = "${local.name_prefix}-${count.index}"
  }
}

resource "aws_security_group" "sg-pub" {
  name_prefix = "${local.name_prefix}-sg-pub"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}-sg-pub"
  }
}

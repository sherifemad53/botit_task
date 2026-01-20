# Create a VPC

resource "aws_vpc" "main" {
  cidr_block = ["10.0.0.0/16"]
}

# Create a subnet

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

# Create a security group

resource "aws_security_group" "main" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an EC2 instance

resource "aws_instance" "main" {
  ami             = "ami-0c55b159cbfafe1f0"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.main.id
  security_groups = [aws_security_group.main.name]
}

# Create a load balancer

resource "aws_lb" "main" {
  name               = "botit-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main.id]
  subnets            = [aws_subnet.main.id]
}

# Create a target group

resource "aws_lb_target_group" "main" {
  name     = "botit-target-group"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

# Create a listener

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "forward"
    forward_config {
      target_group_arn = aws_lb_target_group.main.arn
    }
  }
}

# Create a target group attachment

resource "aws_lb_target_group_attachment" "main" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.main.id
}

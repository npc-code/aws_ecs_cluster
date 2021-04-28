#instance security group file?
#should allow inbound from own ip for ssh access, or should 
resource "aws_security_group" "ecs_instance_sg" {
  name        = "${var.cluster_name}-ecs-instance-sg"
  description = "ALB Security Group"
  vpc_id      = var.vpc_id
  
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = [var.external_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.cluster_name}-ecs-instance-sg"
  }
}
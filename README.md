# aws_ecs_cluster

Creates an aws ec2 ecs cluster.

## Requirements

- terraform
- previously created aws key pair
- profile with credentials under ~/.aws/config or ~/.aws/credentials

## Usage
```
provider "aws" {
  profile = var.profile
  region  = var.region
}

data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

module "ecs_cluster" {
  source                  = ""
  cluster_name            = "my_cluster"
  environment             = "develop"
  min_cluster_size        = 2
  max_cluster_size        = 4
  image_id                = data.aws_ami.ecs_ami.id
  instance_type           = "t3.micro"
  cluster_subnets_private = ["subnet-id-1", "subnet-id-2"]
  vpc_id                  = "some-vpc-id"
  key_name                = "my_key_name"
  external_ip             = "personal_ip/32"
}
```
## Variables

- cluster_name
  - type = string
  - name for your ecs cluster

- cluster_subnets_private
  - type = list
  - subnets to deploy cluster into

- environment
  - type = string
  - environment to deploy into 

- external_ip
  - type = string
  - external ip to use for cluster debugging purposes

- image_id
  - type = string
  - ami id to use for the ec2 instances in the cluster

- instance_type
  - type = string
  - instance type to use

- key_name
  - type = string
  - name of key managed by aws to use for instance debugging

- min_cluster_size
  - type = number
  - default = 1
  - minimum cluster size for the autoscaling group

- max_cluster_size
  - type = number
  - default = 1
  - maximum cluster size for the autoscaling group

- vpc_id
  - type = string
  - vpc id to use for security group creation

## Outputs

- ecs_cluster_id 
  - returns the cluster id

- ecs_cluster_instances_security_group_id
  - returns the security group id used for the instances within
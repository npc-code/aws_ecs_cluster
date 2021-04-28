variable "cluster_name" {
  type = string
  description = "name for your ecs cluster"
}

variable "cluster_subnets_private" {
  type = list
  description = "subnets to deploy cluster into."
}

variable "environment" {
  type = string
  description = "environment to deploy into" 
}

variable "external_ip" {
  type = string
  description = "external ip to use for cluster debugging purposes"
}

variable "image_id" {
  type = string
  description = "ami id to use for the ec2 instances in the cluster"
}

variable "instance_type" {
  type = string
  description = "instance type to use"
}

variable "key_name" {
  type = string
  description = "name of key managed by aws to use for instance debugging"
}

variable "min_cluster_size" {
    type = number
    default = 1
    description = "minimum cluster size for the autoscaling group"
}

variable "max_cluster_size" {
    type = number
    default = 1
    description = "maximum cluster size for the autoscaling group"
}

variable "vpc_id" {
  type = string
  description = "vpc id to use for security group creation"
}




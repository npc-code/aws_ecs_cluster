resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
  capacity_providers = [aws_ecs_capacity_provider.ecs_cluster_capacity_provider.name]
}

resource "aws_launch_configuration" "ecs_cluster_instance_config" {
  name_prefix          = "${var.cluster_name}-launch-configuration-"
  image_id      = var.image_id
  instance_type = var.instance_type
  #could mount devices within user data if need be
  #may be better to move userdata to a templated file
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config && systemctl restart docker && mkdir -p /ecs/data"
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_role.name
  #arguments to play with here:
  key_name = var.key_name
  security_groups = [aws_security_group.ecs_instance_sg.id]
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs_cluster_as_group" {
  name = "${var.cluster_name}-autoscale_group"
  min_size = var.min_cluster_size
  max_size = var.max_cluster_size

  launch_configuration      = aws_launch_configuration.ecs_cluster_instance_config.name
  vpc_zone_identifier       = var.cluster_subnets_private
  #protect_from_scale_in     = true
  #see: https://github.com/hashicorp/terraform-provider-aws/issues/5278
  #may have to forcibly destroy resources from the cli if there is a need to clean things up.
  force_delete = true

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  #more tags
  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }

  tag {
    key = "Name"
    value = "${var.cluster_name}-instance"
    propagate_at_launch = true
  }

  tag {
    key = "Environment"
    value = var.environment
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

#change step sizes to variables, along with target_capacity
#potentially remove managed_scaling
resource "aws_ecs_capacity_provider" "ecs_cluster_capacity_provider" {
  name = "${var.cluster_name}-capacity_provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_cluster_as_group.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 2
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }

  lifecycle {
    create_before_destroy = true
  }


}
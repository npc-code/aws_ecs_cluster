output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_cluster.id
}

output "ecs_cluster_instances_security_group_id" {
  value = aws_security_group.ecs_instance_sg.id
}

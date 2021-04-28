resource "aws_iam_role" "container_instance" {
  name               = "container_instance-${var.environment}-role"
  assume_role_policy = jsonencode(
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
})

  tags = {
    tag-key = "tag-value"
  }

}
resource "aws_iam_instance_profile" "ec2_instance_role" {
  name = "iam_instance_profile-${var.environment}"
  role = aws_iam_role.container_instance.name
}
resource "aws_iam_role_policy_attachment" "ec2_instance" {
  role       = aws_iam_role.container_instance.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "managed_ssm" {
    role       = aws_iam_role.container_instance.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
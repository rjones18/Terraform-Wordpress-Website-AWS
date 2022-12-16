resource "aws_launch_template" "blue_template" {
  name_prefix            = "blue_template"
  image_id               = data.aws_ami.aws_basic_linux.id
  instance_type          = var.ec2_type
  vpc_security_group_ids = [aws_security_group.app_sg.id]
}

resource "aws_autoscaling_group" "blue" {
  name                = "blue_group"
  desired_capacity    = 2
  max_size            = 5
  min_size            = 2
  health_check_type   = "ELB"
  force_delete        = true
  vpc_zone_identifier = [data.aws_subnet.private-a.id]

  launch_template {
    id      = aws_launch_template.blue_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Blue-Server"
    propagate_at_launch = true
  }

  timeouts {
    delete = "5m"
  }
}
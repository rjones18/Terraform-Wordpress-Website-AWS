resource "aws_lb_target_group" "wp_target" {
  name     = "wp-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main_vpc.id
}
resource "aws_autoscaling_attachment" "asg_attachment_wp" {
  autoscaling_group_name = aws_autoscaling_group.wp.id
  lb_target_group_arn    = aws_lb_target_group.wp_target.arn
}
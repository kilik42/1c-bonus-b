# build the asg for tokyo region
resource "aws_autoscaling_group" "tokyo_asg" {
    provider = aws.tokyo
    name                      = "tokyo_asg"
    max_size                  = 2
    min_size                  = 1
    desired_capacity          = 1
    vpc_zone_identifier       = [aws_subnet.tokyo_public_subnet_1.id]
    launch_template {
        id      = aws_launch_template.tokyo_launch_template.id
        version = "$Latest"
    }
    # tags = [
    #     {
    #         key                 = "Name"
    #         value               = "tokyo_asg_instance"
    #         propagate_at_launch = true
    #     }
    # ]
}   




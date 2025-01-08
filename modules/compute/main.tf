resource "aws_instance" "temp_vm" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  security_groups = [var.security_group_id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install httpd -y
              echo "<html><body><h1>Welcome to My Website</h1></body></html>" > /var/www/html/index.html
              systemctl enable httpd
              systemctl start httpd
              EOF

  tags = {
    Name = "TemporaryVM"
  }

  lifecycle {
    prevent_destroy = false
  }

  timeouts {
    delete = "1h"
  }
}

resource "aws_ami_from_instance" "temp_vm_ami" {
  name               = "temporary-vm-ami-${replace(timestamp(), ":", "-")}"
  source_instance_id = aws_instance.temp_vm.id
  description        = "AMI created from the temporary VM"
  tags = {
    Name = "temporary-vm-ami"
  }
}

resource "aws_launch_template" "example" {
  name_prefix   = "example-launch-template"
  image_id      = aws_ami_from_instance.temp_vm_ami.id
  instance_type = var.instance_type

  network_interfaces {
    security_groups = [var.security_group_id]
    associate_public_ip_address = true
  }

  lifecycle {
    create_before_destroy = true
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install httpd -y
              echo "<html><body><h1>Welcome to the homepage of the website</h1><h2>Server number: $(hostname)</h2></body></html>" > /var/www/html/index.html
              systemctl enable httpd
              systemctl start httpd
              EOF
            )
}

resource "aws_autoscaling_group" "example" {
  desired_capacity     = 3
  max_size             = 3
  min_size             = 3
  vpc_zone_identifier  = var.subnet_ids
  health_check_type    = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }

  target_group_arns    = [var.target_group_arn]

  tag {
      key                 = "Name"
      value               = "example-instance"
      propagate_at_launch = true
    }
}

output "ami_id" {
  value = aws_ami_from_instance.temp_vm_ami.id
}


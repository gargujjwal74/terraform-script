resource "aws_security_group" "alb_sg" {
	name = "allow_public"
	description = "allows public traffic to the ALB"
	vpc_id = var.vpc_id
	ingress {
		description = "Traffic from public internet"
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	egress {
		from_port       = 0
		to_port         = 0
		protocol        = "-1"
		cidr_blocks     = ["0.0.0.0/0"]
   }
	tags = {
		Name = "alb_security_group"
	}
}

resource "aws_security_group" "eb_sg" {
	name = "allow_ss_alb_only"
	description = "allows traffic from ss ALB to beanstalk applications"
	vpc_id = var.vpc_id
	egress {
		from_port       = 0
		to_port         = 0
		protocol        = "-1"
		cidr_blocks     = ["0.0.0.0/0"]
	 }
	tags = {
		Name = "eb-app-sg"
	}
}
resource "aws_security_group_rule" "eb_sg_rule" {
  count = 1
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id = aws_security_group.eb_sg.id
}
# SG outputs

output alb_sg_id {
	value = aws_security_group.alb_sg.id
}

output eb_sg_id {
	value = aws_security_group.eb_sg.id
}
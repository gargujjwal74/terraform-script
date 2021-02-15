# ALB outputs

output "public_address" {
	value = aws_alb.ss_alb.dns_name
}

output "ebapp_tg_arn" {
	value= { for k,v in aws_alb_target_group.aws_alb_target_group: k => v.arn } 
}

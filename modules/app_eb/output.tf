# EB apps outputs

output "asg_name" {
	value = {for k,v in aws_elastic_beanstalk_environment.eb-apps-env: k => v.autoscaling_groups } 
}

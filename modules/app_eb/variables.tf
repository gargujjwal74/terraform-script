# EB app variables
variable vpc_id {
	type = string
}

variable elb_subnets {
	type = list
	default = []
}

variable ec2_subnets {
	type = list(map(any))
	description = "Subnet Ids for ebapp ec2_subnets, output from vpc_subnet module"
}


variable elb_sg_id {
	type = string
}
variable ec2_sg_id {
	type = string
}

variable target_gp_arn {
	type = map
}
variable instance_type {
	type = string
}
variable solution_stack_name {
	type = list
}
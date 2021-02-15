provider "aws" {
   region = var.region
   access_key = var.AWS_ACCESS_KEY_ID
   secret_key = var.AWS_SECRET_ACCESS_KEY
}

module vpc_subnet {
	source = "./modules/vpc_subnet"
	region = var.region
}
module alb {
	source = "./modules/alb"
	vpc_id = module.vpc_subnet.vpc_id
	subnets = [module.vpc_subnet.pb_alb_subnet_1a, module.vpc_subnet.pb_alb_subnet_1b]
	sg = module.sg.alb_sg_id

}

module sg {
	source = "./modules/sg"
	vpc_id = module.vpc_subnet.vpc_id
}

module eb_app {
	source = "./modules/app_eb"
	vpc_id = module.vpc_subnet.vpc_id
	elb_subnets = [ module.vpc_subnet.pb_alb_subnet_1a, module.vpc_subnet.pb_alb_subnet_1b]
	ec2_subnets = [ module.vpc_subnet.pv1_private_subnet, module.vpc_subnet.pv2_private_subnet]
	elb_sg_id = module.sg.alb_sg_id
	ec2_sg_id = module.sg.eb_sg_id
	target_gp_arn = module.alb.ebapp_tg_arn
	instance_type = var.instance_type
	solution_stack_name = [var.solution_stack_firmware,var.solution_stack_sensor,var.solution_stack_device,var.solution_stack_admin]
}

module s3_bucket {
	source = "./modules/s3"
}

module dynamodb_table {
	source = "./modules/dynamodb"
}

module vpc_endpoints {
	source = "./modules/vpc_endpoints"
	vpc_id = module.vpc_subnet.vpc_id
	route_table_id = module.vpc_subnet.private_RT
}

#Elastic Beanstalk apps

locals{

		ebapp_name = {
	 	
			firmware = { name: "firmware", value: 0},
        	sensor = { name: "sensor" , value: 1 },
        	device = { name: "device" , value: 2 },
       		admin = {name:  "admin" , value: 3}   
    	}

}


resource "aws_elastic_beanstalk_application" "eb-apps" {
	for_each = local.ebapp_name
	
	name = "${each.value.name}-app"
	description = "${each.value.name}-app"
}

resource "aws_elastic_beanstalk_environment" "eb-apps-env" {
	for_each = local.ebapp_name
	
	name = "${each.value.name}-env"
	application = aws_elastic_beanstalk_application.eb-apps[each.value.name].name
	solution_stack_name = var.solution_stack_name[each.value.value]
	setting {
      namespace = "aws:ec2:vpc"
      name      = "ELBSubnets"
      value     = join(",", sort(var.elb_subnets))
    }
	setting {
		namespace = "aws:ec2:VPC"
		name = "VPCId"
		value = var.vpc_id
	}
	setting {
		namespace = "aws:ec2:VPC"
		name = "Subnets"
		value = join("," ,sort(var.ec2_subnets[*][each.value.name]))
	}
	setting {
		namespace = "aws:autoscaling:launchconfiguration"
		name = "SecurityGroups"
		value = var.ec2_sg_id
	}
	setting{
		namespace = "aws:elb:loadbalancer"
		name      = "SecurityGroups"
		value     = var.elb_sg_id
    }
	setting {
		namespace = "aws:ec2:VPC"
		name = "AssociatePublicIpAddress"
		value = "false"
	}
	setting {
		namespace = "aws:autoscaling:launchconfiguration"
		name = "IamInstanceProfile"
		value = "aws-elasticbeanstalk-ec2-role"
	}
	setting {
		namespace = "aws:autoscaling:launchconfiguration"
		name = "InstanceType"
		value = var.instance_type
	}
	setting {
		namespace = "aws:elasticbeanstalk:environment"
		name = "ServiceRole"
		value = "aws-elasticbeanstalk-service-role"
	}
	setting {
		namespace = "aws:ec2:vpc"
		name = "ELBScheme"
		value = "LoadBalanced"
	}
	setting {
		namespace = "aws:elb:loadbalancer"
		name = "CrossZone"
		value = "true"
	}
	setting {
		namespace = "aws:elasticbeanstalk:command"
		name = "BatchSize"
		value = "30"
	}
	setting {
		namespace = "aws:elasticbeanstalk:command"
		name = "BatchSizeType"
		value = "Percentage"
	}
	setting {
		namespace = "aws:autoscaling:asg"
		name = "Availability Zones"
		value = "Any 2"
	}
	setting {
		namespace = "aws:autoscaling:asg"
		name = "MinSize"
		value = "2"
	}
	setting {
		namespace = "aws:autoscaling:updatepolicy:rollingupdate"
		name = "RollingUpdateType"
		value = "Health"
	}
	
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  for_each = local.ebapp_name
  
  autoscaling_group_name =  aws_elastic_beanstalk_environment.eb-apps-env[each.value.name].autoscaling_groups[0]
  
  #for_each = var.target_gp_arn
  
  #alb_target_group_arn   = each.value

}







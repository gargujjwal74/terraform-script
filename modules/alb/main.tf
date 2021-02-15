# Application Load Balancer
resource "aws_alb" "ss_alb" {
	name = "ss-alb"
	subnets = var.subnets
	security_groups = [var.sg]
	tags = {
		Name = "ss-alb"
	}
}

locals{

		ebapp_name = {
	 	
			firmware = { name: "firmware"},
        	sensor = { name: "sensor"  },
        	device = { name: "device"  },
       		admin = {name:  "admin" }   
    	}

}

#Listeners 
resource "aws_alb_listener" "frontend-listener" {
	load_balancer_arn = aws_alb.ss_alb.arn
	port = "443" #"80" 
	protocol = "HTTPS"
	depends_on        = [aws_alb_target_group.aws_alb_target_group]
	#certificate_arn = "arn:aws:acm:us-east-1:514234668299:certificate/933fe362-07fb-404e-b418-9f173500fcc2"
	default_action {
	#target_group_arn = aws_alb_target_group.admin.arn
	type = "forward"
	
	}
}

#sslcertificate
resource "aws_lb_listener_certificate" "ourservice_ssl_cert" {
  listener_arn    = aws_alb_listener.frontend-listener.arn
  certificate_arn = "arn:aws:acm:us-east-1:514234668299:certificate/933fe362-07fb-404e-b418-9f173500fcc2"
}


#Target Groups
resource "aws_alb_target_group" "aws_alb_target_group" {
	for_each = local.ebapp_name

	name = "${each.value.name}-tg"
	port = 80
	protocol = "HTTP"
	vpc_id = var.vpc_id
}

#path rules 
resource "aws_alb_listener_rule" "aws_alb_listener_rule"{
    for_each = local.ebapp_name

	listener_arn = aws_alb_listener.frontend-listener.arn
    action {    
		  type = "forward"    
		  target_group_arn = aws_alb_target_group.aws_alb_target_group[each.value.name].arn
    }   
    condition {    
		 
		 path_pattern {
      		values = ["/${each.value.name}/*"]
    	}
	}
} 


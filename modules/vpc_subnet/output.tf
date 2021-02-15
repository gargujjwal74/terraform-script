output "vpc_id" {
	value = aws_vpc.symptomsense.id
}

#Public Subnet ID's

output "pb_alb_subnet_1a" {
	value = aws_subnet.public_alb_1a.id
}
output "pb_alb_subnet_1b" {
	value = aws_subnet.public_alb_1b.id
}

#Private Subnet ID's
output "pv1_private_subnet" {
	value = {for k,v in aws_subnet.private_subnet1a : k => v.id } 
}

output "pv2_private_subnet" {
	value = {for k,v in aws_subnet.private_subnet1b : k => v.id } 	
}


#Private Route Table ID
output "private_RT" {
	value = aws_route_table.private_RT.id
}
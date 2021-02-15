#VPC
resource "aws_vpc" "symptomsense" {
	cidr_block = "10.0.0.0/16"
	instance_tenancy = "default"
	enable_dns_support = "true"
	enable_dns_hostnames = "true"
	enable_classiclink = "false"
	tags = {
		Name = "symptomsense-vpc"
	}
}


locals{
	
	app_public_subnets = {
        public_alb_1a = { prefix: "10.0.1.0/24" },
        public_alb_1b = { prefix: "10.0.2.0/24"  } 
    }

	app_private_subnets_1a = {
        firmware = { prefix: "10.0.3.0/24" },
        sensor = { prefix: "10.0.5.0/24"  },
        device = { prefix: "10.0.7.0/24"  },
        admin = {prefix: "10.0.9.0/24"  }
    }

	app_private_subnets_1b = {
        firmware = { prefix: "10.0.4.0/24" },
        sensor = {prefix: "10.0.6.0/24"  },
        device = { prefix: "10.0.8.0/24"  },
        admin = {prefix: "10.0.10.0/24"  }
    }

}

# Public Subnets
resource "aws_subnet" "public_alb_1a" {
	vpc_id = aws_vpc.symptomsense.id
	cidr_block = "10.0.1.0/24"
	map_public_ip_on_launch = "true"
	availability_zone = "${var.region}a"
	tags = {
		Name = "public_alb_1a"
	}
}

resource "aws_subnet" "public_alb_1b" {
	vpc_id = aws_vpc.symptomsense.id
	cidr_block = "10.0.2.0/24"
	map_public_ip_on_launch = "true"
	availability_zone = "${var.region}b"
	tags = {
		Name = "public_alb_1b"
	}
}



#Private Subnets
resource "aws_subnet" "private_subnet1a" {
	for_each = local.app_private_subnets_1a

	vpc_id = aws_vpc.symptomsense.id
	cidr_block = each.value.prefix
	map_public_ip_on_launch = "false"
	availability_zone = "${var.region}a"
	tags = {
		Name = "pv1_${each.key}_ss"
	}
}

resource "aws_subnet" "private_subnet1b" {
	for_each = local.app_private_subnets_1b

	vpc_id = aws_vpc.symptomsense.id
	cidr_block = each.value.prefix
	map_public_ip_on_launch = "false"
	availability_zone = "${var.region}b"
	tags = {
		Name = "pv1_${each.key}_ss"
	}
}



# Internet Gateway 
resource "aws_internet_gateway" "symptomsense_igw" {
	vpc_id = aws_vpc.symptomsense.id
	tags = {
		Name = "ss_igw"
	}
}

#Public Route Table
resource "aws_route_table" "public_RT" {
	vpc_id = aws_vpc.symptomsense.id
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.symptomsense_igw.id
	}
	tags = {
		Name = "public_RT"
	}
}

#Private Route Table
resource "aws_route_table" "private_RT" {
	vpc_id = aws_vpc.symptomsense.id
	route {
		nat_gateway_id = aws_nat_gateway.nat_gw.id
		cidr_block = "0.0.0.0/0"
    }
	tags = {
		Name = "private_RT"
	}
}

#Public Subnet Associations
resource "aws_route_table_association" "public_assoc1" {
	subnet_id = aws_subnet.public_alb_1a.id
	route_table_id = aws_route_table.public_RT.id
}
resource "aws_route_table_association" "public_assoc2" {
	subnet_id = aws_subnet.public_alb_1b.id
	route_table_id = aws_route_table.public_RT.id
}


#Private Subnet Associations
resource "aws_route_table_association" "private_assoc1" {
	for_each = local.app_private_subnets_1a

	subnet_id = aws_subnet.private_subnet1a[each.key].id
	route_table_id = aws_route_table.private_RT.id
}
resource "aws_route_table_association" "private_assoc2" {
	for_each = local.app_private_subnets_1b
	
	subnet_id = aws_subnet.private_subnet1b[each.key].id
	route_table_id = aws_route_table.private_RT.id
}


#Nat Gateway Configuration
resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id  = aws_subnet.public_alb_1a.id
}


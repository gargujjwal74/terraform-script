#S3 Endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.us-east-1.s3"
  tags = { 
	Name = "s3-endpoint"
  }
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = var.route_table_id
}


# DynamoDB Endpoint
resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.us-east-1.dynamodb"
  tags = {
	Name = "DDB-endpoint"
  }
}

resource "aws_vpc_endpoint_route_table_association" "private_dynamodb" {
  vpc_endpoint_id = aws_vpc_endpoint.dynamodb.id
  route_table_id  = var.route_table_id
}
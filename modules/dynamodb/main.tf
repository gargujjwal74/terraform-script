# DynamoDb resources

resource "aws_dynamodb_table" "dynamodbtable" {
  name           = "SymptomsenseDatabase"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "UserId"
  range_key      = "Username"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "Username"
    type = "S"
  }
  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }


  tags = {
    Name        = "SymptomsenseDatabase"
  }
}
#S3 resources 
resource "aws_s3_bucket" "bucket" {
  bucket = "symptomsense-s3-bucket"
  acl    = "private"
  tags = {
    Name        = "symptomsense-s3-bucket"
  }
}
#output main

output "load_balancer_dns" {
	value = module.alb.public_address
}
output "dynamodb_table_name" {
	value = module.dynamodb_table.ddb_table_id
}
output "s3_bucket_name" {
	value = module.s3_bucket.bucket_name
}
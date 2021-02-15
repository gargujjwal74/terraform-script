# terraform-script
Initialization:
```
terraform init

terraform plan -var-file="terraform.tfvars"
```

Apply:
```
terraform apply -auto-approve -var-file="terraform.tfvars"
 ```

To set lots of variables, it is more convenient to specify their values in a variable definitions file 
(with a filename ending in either .tfvars or .tfvars.json) like The terraform.tfvars 
and then specify that file on the command line with -var-file

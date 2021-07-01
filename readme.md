Create a file named backend.tfvars with content:
```
aws_profile       = ""
aws_region        = "ap-southeast-1"
aws_s3_bucket     = ""
```

Specify this file name in a command line option to the terraform command:
```
terraform init -backend-config=backend.tfvars
```
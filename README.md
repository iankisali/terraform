# Terraform
Infrastructure as Code with tf

### Initialize a working dir and install providers defined in tf config (main.tf)

- `terraform init`

### Previewing tf actions

- `terraform plan`

### Applying whole tf configuration file

- `terraform apply`

### Applying configuration with variables

- `terraform apply -var-file target_resource.target_name`

### Destroying one specific resource

- `terraform destroy -target target_resource.target_name` -> not advisable instead remove resource from tf file then use `terraform apply`

### Destroy complete infrastructure

- `terraform destroy`

### Compare between desired and current state

- `terraform plan`

### Apply configuration without confirming

- `terraform apply -auto-approve`

### Show resources and components from current state

- `terraform state list`

### Show current state of specific resource/data

- `terraform state show aws_vpc.myapp-vpc`

### Using cli in terraform apply 

-  `terraform apply -var "subnet_cidr_block=10.0.10.0/24"`

### Applying configuration with variables

- `terraform apply -var-file terraform-dev.tfvars` -> by default the variable file is `terraform.tfvars` and doesn't require to pass variable file

### Setting avail_zone as custom tf environment variable

- `export TF_VAR_avail_zone="eu-north-1a`
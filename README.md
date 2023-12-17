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
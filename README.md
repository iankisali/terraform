# Terraform
Infrastructure as Code with Terraform. Tf is used to automate and manage infrastructer such as vpc, subnets, route table, internet gateway etc.
Terraform is declarative meaning that you define what end result you want.
Two main components of terraform include:
- `tf-config`
- `state`
- `terraform.state` is a JSON file where tf terraform stores the state about your real world resources of your managed infrastructure

*Datasource* alows data to be fetched for use in tf configuration

*Resource* creates a new component

*Provider* defines the cloud provider i.e aws, azure or gcp

*Output* are like function return values

*Variables* are like functon argument

*Provisioner* are used to run scripts inside the resouces created.

*Modules* 

The difference between a `resource` and `data` is that resource is something created by and controlled by the script and data source in what terraform expects to exist.

### Initialize a working dir and install providers defined in tf config (main.tf)

- `terraform init`

### Validates the terraform script

- `terraform validate`

### Checks syntax correctness

- `terraform format`

### Previewing tf actions

- `terraform plan`

### Applying whole tf configuration file

- `terraform apply`

### Applying whole tf configuration file automatically without confirming

- `terraform apply --auto-approve`

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

### Terraform vpc module [link](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)

## Best Practices
1. Don't include sensitive data into configuration file i.e public key
2. Use terraform apply with configuration file to make infrastructure changes instead of executing commands directly.
3. Create own vpc and its infrastructure not default components
4. Store .pem file ssh private key in .ssh folder adn restrict permissions
5. Provisioners not recommended instead use `user_data` if available -> breaks idempotency

## Challenges Encountered
When referencing the public key for ssh I got the error as:

```
Error: Invalid function argument
│
│   on main.tf line 168, in resource "aws_key_pair" "ssh-key":
│  168:     public_key = file(var.public_key_location)
│     ├────────────────
│     │ while calling file(path)
│     │ var.public_key_location is "/c/Users/admin/.ssh/id_rsa.pub"
│
│ Invalid value for "path" parameter: no file exists at "/c/Users/admin/.ssh/id_rsa.pub"; this function works only with files that are distributed as part of the configuration source code, so if this file will be        
│ created by a resource in this configuration you must instead obtain this result from an attribute of that resource.
```
The path cannot be found. The solution to this is that the correct path in windows is:

- `C:/Users/admin/.ssh/id_rsa.pub`

The command to obtain this path is:
- Open python in terminal using command`python`
- In python shell paste in following:
    ```
    import os
    print(os.path.abspath("id_rsa.pub"))
    ```
- Expected output:
`C:\Users\admin\.ssh\id_rsa.pub`
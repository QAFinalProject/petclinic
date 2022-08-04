# Petclinic

Run Spring-Petclinic on the AWS cloud via Jenkins pipeline

App Front End - [Spring-Petclinic-Angular](https://github.com/spring-petclinic/spring-petclinic-angular)

App Back End - [Spring-Petclinic-Rest](https://github.com/spring-petclinic/spring-petclinic-rest)

## Production

### Set-up

#### Step 1

Update your aws key in terraform-vm/terraform.tfvars.

Run following commands in terraform-vm folder.

- Terraform init
- Terraform plan
- Terraform apply (type yes when prompted)

This will automatically update the IP addresses for Ansible, Jenkins Pipeline, Nginx-configuration, and Environments for front end app.

#### Step 2

- change directory to main petclinic
- git add *
- git commit -m "your message"
- git push

### Step 3

This will trigger a Jenkins webhook which will deploy the application.





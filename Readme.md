# AWS with Terraform

This project describe how to manage Amazon Web Services infrastructure with Terraform.

For the moment there is one example: 

* VPC deployment with a public subnet and Nat Gateway and private subnet routed to Nat Gateway

## Deployment

Go to the example that you want to instanciate and do :
`terraform plan` or `terraform apply`



If you want to customize some variables. Create a file `terraform.tfvars`
```
vpc_cidr="<vpc_cidr>"
...
```

Enjoy !

# VPC with nat Gateway

This topology will deploy a VPC composed of two subnets 
* Public Subnet that a Nat Gateway wich routes every external traffic through an Internet Gateway 
* Private Subnet that routes every external traffic through an Nat Gateway

The output display the Private Subnet ID :
* Every Instance launch inside will have access to Internet through the Nat Gateway and with only a private IP

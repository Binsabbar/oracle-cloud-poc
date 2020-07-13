# oracle-cloud-poc

I am experimenting with OracleCloud and wanted to try Terraform with it. Here is a simple Terraform project that create a basic infrastructure.


The basic configuration consists of the following:

* One VPC with Internet Gateway and DHCP.
* Two Subnets - one private and the other public.
* Default Security List on the network to allow port 80 and 443
* Two Default Security Groups (They are not applied to instances, you have to pass their IDs): 
    * One allows SSH from safe IPs to public instance.
    * The other allows communication between public and private subnet
* Optional HTTP/S Load Balancer
 
## Managing Different Environments
I have seen multiple approaches when it comes to managing different environments in Terraform. My approach was to create generic modules, then customise each environment
differently. I am also using different backend to store Terraform states (Workspaces). Seems like it does suit my current need. Here is the dir structure:
```
networking/
identity/
computing/
environments/
  production/
      main.tf             <--------- (symlink)
      variables.tf        <--------- (symlink)
      instance-options.tf <--------- (symlink)
      configurations.tf.  <--------- using production workspace in Terraform backend
      prod.tf
      instances.tf
  uat/
      main.tf             <--------- (symlink)
      variables.tf        <--------- (symlink)
      instance-options.tf <--------- (symlink)
      configurations.tf.  <--------- using uat workspace in Terraform backend
      uat.tf
      instances.tf
main.tf
variables.tf
instance-options.tf
```

To create different environments (prod, uat, dev), it is assumed that they same overall design.
1. Create a new folder under environments dir, and create `configurations.tf` file to configure how you want to manage your Terraform state.
2. symlink the following: `main.tf`, `variables.tf` and `instance-options.tf` to the new environment directory.
3. customise the environment as you wish. You probably want to configure the instances you want to create + security groups per environment.

# Work In Progress (WIP):

# To dos:
This is WIP example. I am still planning to find a way to:
1. Mange IAM and policies in an organised way. Probably if I do I will store Terraform state in a different workspace.
4. Allows for multiple subnets configurations (currently the module will create two only)
5. Add Internet Gateway for private subnet so they can reach the internet.
2. Manage DNS records.

 

 Well, that's it. Hope someone will find it useful :D 

 

 Cheers!

 

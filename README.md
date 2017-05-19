# Democracy Club Terraform Provisioning scripts

## Currently supported projects

- [Election Leaflets](https://github.com/DemocracyClub/electionleaflets/)

## Usage

1. [Install Terraform](https://www.terraform.io/downloads.html)
2. Initialise the project using the appropriate AWS profile
```
cd projects/electionleaflets
AWS_PROFILE=democlub terraform init
terraform get
```
3. Run `plan` to see what changes are needed
```
AWS_PROFILE=democlub terraform plan
```
4. Run `apply` to apply them
```
AWS_PROFILE=democlub terraform apply
```


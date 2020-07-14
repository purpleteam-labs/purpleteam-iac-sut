<div align="center">
  <br/>
  <a href="https://purpleteam-labs.com" title="purpleteam">
    <img width=900px src="https://gitlab.com/purpleteam-labs/purpleteam/raw/master/assets/images/purpleteam-banner.png" alt="purpleteam logo">
  </a>
  <br/>
<br/>
<h2>purpleteam infrastructure as code for systems under test</h2><br/>

</div>

# ACM Certificate Quota

Make sure this is set to 2000 per region where we require certificates, submit support ticket if required. Although the [documentation](https://docs.aws.amazon.com/acm/latest/userguide/acm-limits.html) says it's already set at this, by default it's actually only set to 20, which means you'll run out quickly.

* Region: Asia Pacific (Sydney)  
  Limit: Number of ACM certificates  
  New limit value: 2000
* Region: US East (Northern Virginia)  
  Limit: Number of ACM certificates  
  New limit value: 2000

# AWS Policies

Set these up.

# ECS

Log in as root user, navigate to ECS -> Account Settings... For each region we operate in:

Setting scope: Set for root (override account default)

Check the following check boxes:  
* [x] Container instance
* [x] Service
* [x] Task

Doing the above should also automatically do the following. Confirm.

Setting scope: Set for specific IAM user  
IAM user with console only access. Let's call this purpleteam-iac-sut

Check the following check boxes:  
* [x] Container instance
* [x] Service
* [x] Task

Setting scope: Set for specific IAM user  
IAM user with cli access only. Let's call this purpleteam-iac-sut-cli

Check the following check boxes:  
* [x] Container instance
* [x] Service
* [x] Task

## Resources to work the above out

* Google search for "[Unable to register as a container instance with ECS: InvalidParameterException: Long arn format must be enabled for tagging](https://www.google.com/search?q=Unable+to+register+as+a+container+instance+with+ECS%3A+InvalidParameterException%3A+Long+arn+format+must+be+enabled+for+tagging&oq=Unable+to+register+as+a+container+instance+with+ECS%3A+InvalidParameterException%3A+Long+arn+format+must+be+enabled+for+tagging&aqs=chrome..69i57.315j0j7&client=ubuntu&sourceid=chrome&ie=UTF-8)" which was produced in terraform apply
* https://github.com/terraform-providers/terraform-provider-aws/issues/7373
* https://github.com/terraform-providers/terraform-provider-aws/issues/6481
* Google search for "[ecs-agent.log Unable to register as a container instance with ECS: InvalidParameterException: Long arn](https://www.google.com/search?client=ubuntu&sxsrf=ACYBGNSsecSEtrcmODDBFnttGIK7M3Ew3g%3A1574570447565&ei=zwnaXZiLItn6rQG74oP4BQ&q=ecs-agent.log+Unable+to+register+as+a+container+instance+with+ECS%3A+InvalidParameterException%3A+Long+arn&oq=ecs-agent.log+Unable+to+register+as+a+container+instance+with+ECS%3A+InvalidParameterException%3A+Long+arn&gs_l=psy-ab.3...107682.107682..108207...0.0..0.0.0.......0....2j1..gws-wiz.nh2EDUF3_BI&ved=0ahUKEwjYrs2BhILmAhVZfSsKHTvxAF8Q4dUDCAs&uact=5)" which the ecs-agent.log was telling us
* [Migrating your Amazon ECS deployment to the new ARN and resource ID format](https://aws.amazon.com/blogs/compute/migrating-your-amazon-ecs-deployment-to-the-new-arn-and-resource-id-format-2/)

## Troubleshooting

[ECS container instances not connected to the cluster](https://aws.amazon.com/premiumsupport/knowledge-center/ecs-agent-disconnected/)  
`systemctl status ecs` for the status of the ecs agent

# Terraform

The architecture of this Terraform project was inspired by [this Terraform talk](https://www.hashicorp.com/resources/evolving-infrastructure-terraform-opencredo). The [how we organize terraform code at 2nd watch](https://www.2ndwatch.com/blog/how-we-organize-terraform-code-at-2nd-watch/) blog post also played a small part.

The implementation of this Terraform project was [inspired](https://github.com/freedomofkeima/terraform-docker-ecs/issues/4) by [@freedomofkeima](https://github.com/freedomofkeima) with the [terraform-docker-ecs](https://github.com/freedomofkeima/terraform-docker-ecs) project.

# Install Terraform

1. [Download](https://www.terraform.io/downloads.html) the Terraform zip file, the checksums, and sig file 
2. Import the hashicorp public GPG key (first time installing only)
3. Verify the checksum file with the sig
4. Verify the checksum in the checksums file matches the binary  
   Step 2,3,4 detailed [here](https://www.hashicorp.com/security)
5. `sudo unzip ~/Downloads/terraform_[version]_linux_amd64.zip -d /opt/`
6. `sudo ln -s /opt/terraform /usr/local/bin/terraform`

Hashicorp GPG pub key on [hashicorp](https://www.hashicorp.com/security), on [keybase](https://keybase.io/hashicorp#show-public)

# Install [Terragrunt](https://terragrunt.gruntwork.io/) and configure

Using the [Manual install](https://terragrunt.gruntwork.io/docs/getting-started/install/#manual-install), similar to installing Terraform.

In the `roots` directory:

* Locate and rename the `common_vars.example.yaml` file to `common_vars.yaml` and configure the values within
* Locate and rename the `terragrunt.example.hcl` file to `terragrunt.hcl` and configure the values within

In each root directory add and configure the following file if it doesn't exist:

* `terragrunt.hcl`

# Configure Terraform

Make sure the terraform oh-my-zsh plugin is setup. This will give you a prompt that displays which terraform workspace is selected, Ask me about this if unsure.

Assuming the aws cli has been [configured](https://gitlab.com/purpleteam-labs/purpleteam/-/wikis/local/local-setup#validating-sam-templates)

Each terraform root aws provider (in the main.tf file, or each specific root `variables.tf`) needs to specify the correct aws `profile`, if this is not correct, you could clobber or destroy an incorrect set of infrastructure. This needs to be configured in a `.env` file in the top directory of this repository. The file contents will look like the following, adjust to suite your environment:

```shell
# Used in buildAndDeployCloudImages.sh via npm script
# Used in terragrunt.hcl to load these values into roots that require them. Double quotes are required by Terraform, otherwise it trys to interpret the values as variables. 
AWS_REGION="your-aws-region"
AWS_PROFILE="your-aws-profile"
# The following variable is only used in the buildAndDeployCloudImages.sh
AWS_ACCOUNT_ID=your-aws-account-id
```

The above values are read into all Terraform roots that specify the variables. This can be seen in the `extra_arguments "custom_env_vars_from_file"` block within the `terraform` block of the `terragrunt.hcl` in the `roots` directory that you renamed above.

The `.env` file is also consumed within the `buildAndDeployCloudImages.sh` file that is executed as an npm script, where the variables from the `.env` file are exported to the current shell.

Create tokens for all devices that need to work with the remote state in Terraform Cloud:

1. [Create](https://www.terraform.io/docs/commands/cli-config.html) `~/.terraformrc` file for each device (desktop, laptop)
2. Add the specific devices token

From each root within the Terraform project run ~~`terraform init`~~ `terragrunt init`, or just watch [this video](https://www.hashicorp.com/blog/introducing-terraform-cloud-remote-state-management) and do likewise.

If you run ~~`terraform plan`~~ `terragrunt plan` and receive an error similar to:  
`Error: Failed to instantiate provider "aws" to obtain schema: fork/exec .../purpleteam-iac-sut/tf/roots/2_nw/.terraform/plugins/linux_amd64/terraform-provider-aws_v2.24.0_x4: permission denied`  
This is probably because the executable bit is not turned on on `terraform-provider-aws_v2.24.0_x4`

When creating a new Terraform root (or possibly even just workspace), make sure the _Execution Mode_ in the Terraform cloud is set to _Local_ rather than _Remote_ in the General Settings of the new workspace in the Web UI.

# Install Amazon ECR Credential Helper

This is required to push images to ECR.

When I did this, the package wasn't available for my distro, so I just downloaded the [latest binary](https://github.com/awslabs/amazon-ecr-credential-helper/releases/) and put it in the same place as terraform and symlinked it.  
You'll also need to add the following to `~/.docker/config.json`  

```json
{
  "credHelpers": {
    "your_aws_account_id_here.dkr.ecr.your_aws_region_here.amazonaws.com": "ecr-login"
  }
}
```

Above details and more found [here](https://github.com/awslabs/amazon-ecr-credential-helper). If you have issues authenticating with ECR, follow [these steps](https://github.com/awslabs/amazon-ecr-credential-helper/issues/63#issuecomment-328318116).

# Install JQ

`apt-get install jq`  
This is used in the `buildAndDeployCloudImages.sh` script in `purpleteam-orchestrator`.

# Deployment Steps (regular tf workflow)

The following are the Terraform roots in this project and the order in which they should be applied:

1. **static** (IAM roles, policies)  
   
   Sometime now before you `apply` the `contOrc` root, make sure you have built the Docker images you want to host and pushed them to their ECR repositories. To do this, from the top level repository directory, run the following command:  
   `npm run buildAndDeploySUTCloudImages`  



<div align="center">
  <br/>
  <a href="https://purpleteam-labs.com" title="purpleteam">
    <img width=900px src="https://github.com/purpleteam-labs/purpleteam/blob/main/assets/images/purpleteam-banner.png" alt="purpleteam logo">
  </a>
  <br/>
<br/>
<h2>purpleteam infrastructure as code for systems under test (SUTs)</h2><br/>
This is what PurpleTeam-Labs uses to set-up systems to attack and test that it's working as we think it should. Feel free to run yourself if you are taking <em>PurpleTeam</em> for a test drive, or just want to attack some <em>SUT</em>s to hone your red teaming skills.
<br/><br/>

<a href="https://github.com/purpleteam-labs/purpleteam-iac-sut/blob/main/licenses/mit.md" title="license">
  <img src="https://img.shields.io/badge/license-MIT-green.svg" alt="license"/>
</a>

<a href="https://github.com/purpleteam-labs/purpleteam-iac-sut/releases" title="latest release">
  <img src="https://img.shields.io/github/v/release/purpleteam-labs/purpleteam-iac-sut?color=%23794fb8&include_prereleases" alt="GitHub release (latest SemVer including pre-releases)">
</a>

<br/><br/><br/>
</div>

# AWS Account Provisioning

* Set-up email account

As Root Account:

* Change [Payment Currency Preference](https://console.aws.amazon.com/billing/home?#/account) to your currency
* Configure Security Challenge Questions
* Activate IAM User and Role Access to Billing Information
* Enable MFA
* Record account ID and Canonical User ID in password manager
* [Disable Security Token Service (STS)](https://console.aws.amazon.com/iam/home?region=ap-southeast-2#/account_settings) for all regions we don't need
* [Launch Cost Explorer](https://console.aws.amazon.com/billing/home?#/costexplorer)
* [Billing Preferences](https://console.aws.amazon.com/billing/home?#/preferences): Turn on:
   * Receive PDF Invoice By Email
   * Receive Free Tier Usage Alerts - add email address
   * Receive Billing Alerts
* Create a Cost [Budget](https://console.aws.amazon.com/billing/home?#/budgets/overview) for Monthly with alerts:
   * Threshold: 50% of budgeted amount, Trigger: Actual, Email recipients: you
   * Threshold: 100% of budgeted amount, Trigger: Forecasted, Email recipients: you, 2IC
   * Threshold: 100% of budgeted amount, Trigger: Actual, Email recipients: you, 2IC

1. Create User groups
2. Create Permissions/Policies - update account Ids in source controlled policies before applying
3. Add policies to respective Groups
4. Add IAM user
   * Add user to group(s)
   * Assign MFA
5. Add CLI IAM user
   * Add user to group(s)
   * Create Access keys for devices that need access
   * Apply Access keys to said devices

# ACM Certificate Quota

Make sure this is set to 2000 per region where we require certificates, submit support ticket if required. Although the [documentation](https://docs.aws.amazon.com/acm/latest/userguide/acm-limits.html) says it's already set at this, by default it's actually only set to 20, which means you'll run out quickly.

* Region: Asia Pacific (Sydney)  
  Limit: Number of ACM certificates  
  New limit value: 2000
* Region: US East (Northern Virginia)  
  Limit: Number of ACM certificates  
  New limit value: 2000

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

# Install [boto3](https://github.com/boto/boto3)

The `nw` root uses python3 to run getNlbPrivateIps.py. pip3 needs to be installed to install boto3.

1. [Install pip3 on Linux Mint](https://linuxhint.com/installing_pip_linux_mint/):
   1. Confirm you have python3 installed by running: `python3 --version`
   2. `sudo apt update && sudo apt install python3-pip`
   3. Run `pip3 --version` to confirm you now have pip3 installed
2. Install boto3 with: `pip3 install boto3`

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

Or on Linux via the package sources. Details [here](https://www.terraform.io/docs/cli/install/apt.html).

# Install [Terragrunt](https://terragrunt.gruntwork.io/) and configure

Using the [Manual install](https://terragrunt.gruntwork.io/docs/getting-started/install/#manual-install), similar to installing Terraform.

In the `roots` directory:

* Locate and rename the `common_vars.example.yaml` file to `common_vars.yaml` and configure the values within
  * You will need a domain and it's DNS configured in CloudFlare
  * For the first (default) _SUT_ we are using ([NodeGoat](https://github.com/OWASP/NodeGoat))
    * Chetan Karande maintains a hosted version running at [https://nodegoat.herokuapp.com/](https://nodegoat.herokuapp.com/)
    * Once this project is `apply`ed you should be able to see NodeGoat running at [https://nodegoat.sut.<your-domain-name.com>](https://nodegoat.sut.your-domain-name.com)  
      For the case of purpleteam-labs, that will be [https://nodegoat.sut.purpleteam-labs.com](https://nodegoat.sut.purpleteam-labs.com). Currently we only have this instance running during our testing
  * Add as many or few <em>SUT</em>s as you require
* Locate and rename the `terragrunt.example.hcl` file to `terragrunt.hcl` and configure the values within

In each root directory add and configure the following file if it doesn't exist:

* `terragrunt.hcl`

# Configure Terraform

Optional: Set-up the terraform oh-my-zsh plugin. This will give you a prompt that displays which terraform workspace is selected, Ask Kim about this if unsure.

Assuming the aws cli has been [configured](https://github.com/purpleteam-labs/purpleteam-lambda/blob/main/README.md)

Each terraform root aws provider (in the main.tf file, or each specific root `variables.tf`) needs to specify the correct aws `profile`, if this is not correct, you could clobber or destroy an incorrect set of infrastructure. This needs to be configured in a `.env` file in the top directory of this repository. The file contents will look like the following, adjust to suite your environment:

```shell
# Used in buildAndDeployCloudImages.sh via npm script
# Used in terragrunt.hcl to load these values into roots that require them. Double quotes are required by Terraform, otherwise it trys to interpret the values as variables. 
AWS_REGION="your-aws-region"
AWS_PROFILE="your-aws-profile"
AWS_ACCOUNT_ID="your-aws-account-id"
```

The above values are read into all Terraform roots that specify the variables. This can be seen in the `extra_arguments "custom_env_vars_from_file"` block within the `terraform` block of the `terragrunt.hcl` in the `roots` directory.

The `.env` file is also consumed within the `buildAndDeployCloudImages.sh` file that is executed as an npm script, where the variables from the `.env` file are exported to the current shell.

Each root directory requires a `terraform.tfvars` file to initialise the sibling `variables.tf` variables. Don't worry, if you miss this step, Terraform will inform you.

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

When we did this, the package wasn't available for our distro, so we just:

1. Download the [latest binary](https://github.com/awslabs/amazon-ecr-credential-helper/releases/)
2. Checksum it
3. Rename it to `docker-credential-ecr-login`
4. Put it in `/opt/` and symlink it to `/usr/local/bin/docker-credential-ecr-login`
5. You'll also need to add the following to `~/.docker/config.json`  
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
This is used in the `buildAndDeployCloudImages.sh` script in the top level directory of this repository.

# Deployment Steps (regular tf workflow)

The following are the Terraform roots in this project and the order in which they should be applied:

1. **static** (IAM roles, policies, ECR repository creation)  
   
   Sometime now before you `apply` the `contOrc` root, make sure you have built the Docker images you want to host and pushed them to their respective ECR repositories (created in the static root). To do this:
   * You will need to have cloned the git repositories that you want hosted (NodeGoat for this example) in Docker containers to the same level directory that this git repository will be cloned to, you can see this location specified in the npm scripts
   * From the top level directory of this repository, run the following command:  
     `npm run buildAndDeploySUTCloudImages`
2. **nw** (network, VPC, load balancer, api certificates, api subdomain)
3. **contOrc** (SSH pub keys, EC2 Cloudwatch log groups, ECS, autoscaling)
4. **api** (_SUT_ APIs (Api Gateway), Cloudwatch log groups, VpcLink, _SUT_ subdomain(s))

Each root's dependencies are defined in their `terragrunt.hcl`.  
The roots applied earliest require the least amount of ongoing changes making for faster iterative development of the later roots, for example the static root hardly ever needs re`apply`ing, the nw root usually only needs re`apply`ing when a _SUT_ is added/removed/or with nw related modification.

When we add or remove a _SUT_, the `nw` root onwards will need to be re-applied.

We use [Terraform Cloud](https://www.terraform.io/docs/cloud/free/index.html) to [store our state remotely](https://www.hashicorp.com/blog/introducing-terraform-cloud-remote-state-management/) so each developer can [collaborate with a single source of state](https://www.hashicorp.com/blog/terraform-collaboration-for-everyone/)

# Tuning AWS Permissions

Getting AWS permissions right can be a pain. This is how we do it.

1. Create a policy that `Allow`s all actions of the AWS service (`ec2:*` for example) specific to the Terraform resource you want to create. Now assuming you have all the permissions to do what Terraform needs to do...
2. From the tf root within the project, run `terraform plan` then `terraform apply`
3. Browse to the CloudTrail Event history, and wait for the logs to come through, this can take a while (aprx 15-20 minutes). Filter on User name of [your-aws-cli-profile], you can also add another filter of Event source for the resource you want to see. Now you can copy the Event names of each log event along with the Event source prefix (`ec2` for example) and add to the `Allow`d `Action` array in the policy you want to modify. Then remove the wildcard action (`ec2:*` for example)
4. Try step 2 again, you may need to run `terraform destroy` first. If you get an error with a `Encoded authorization failure message`:  
   1. You will need to add the `sts:DecodeAuthorizationMessage` action to a policy that your user has
   2. Then to retreive the decoded error run the following command:  
     `aws sts decode-authorization-message --encoded-message [encodedmessage] --profile [your-aws-cli-profile]`  
     Details on this and interpreting the output can be found under the heading "Using DecodeAuthorizationMessage to troubleshoot permissions" [here](https://aws.amazon.com/blogs/security/demystifying-ec2-resource-level-permissions/)

Details for more granular policies:

* https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ExamplePolicies_EC2.html
* https://github.com/hashicorp/terraform/issues/2834

# CloudWatch

To make reading logs easier [set the time zone to local](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/modify_graph_date_time.html#set-time-zone-Cloudwatch-graph)

# Useful Resources

* Terraform [best practises and naming conventions](https://www.terraform-best-practices.com/naming)
* [Why Terraform over CloudFormation](https://hackernoon.com/your-infrastructure-as-code-cloudformation-vs-terraform-34ec5fb5f044)

## Contribution

Please open an [issue](https://github.com/purpleteam-labs/purpleteam/issues) to discus the proposed change before submitting a [pull request](https://github.com/purpleteam-labs/purpleteam-iac-sut/pulls).

## License

Copyright [Kim Carter](https://binarymist.io), Licensed under [MIT](https://github.com/purpleteam-labs/purpleteam-iac-sut/blob/main/LICENSE).


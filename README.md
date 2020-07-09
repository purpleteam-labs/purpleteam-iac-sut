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

## ECS

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

### Resources to work the above out

* Google search for "[Unable to register as a container instance with ECS: InvalidParameterException: Long arn format must be enabled for tagging](https://www.google.com/search?q=Unable+to+register+as+a+container+instance+with+ECS%3A+InvalidParameterException%3A+Long+arn+format+must+be+enabled+for+tagging&oq=Unable+to+register+as+a+container+instance+with+ECS%3A+InvalidParameterException%3A+Long+arn+format+must+be+enabled+for+tagging&aqs=chrome..69i57.315j0j7&client=ubuntu&sourceid=chrome&ie=UTF-8)" which was produced in terraform apply
* https://github.com/terraform-providers/terraform-provider-aws/issues/7373
* https://github.com/terraform-providers/terraform-provider-aws/issues/6481
* Google search for "[ecs-agent.log Unable to register as a container instance with ECS: InvalidParameterException: Long arn](https://www.google.com/search?client=ubuntu&sxsrf=ACYBGNSsecSEtrcmODDBFnttGIK7M3Ew3g%3A1574570447565&ei=zwnaXZiLItn6rQG74oP4BQ&q=ecs-agent.log+Unable+to+register+as+a+container+instance+with+ECS%3A+InvalidParameterException%3A+Long+arn&oq=ecs-agent.log+Unable+to+register+as+a+container+instance+with+ECS%3A+InvalidParameterException%3A+Long+arn&gs_l=psy-ab.3...107682.107682..108207...0.0..0.0.0.......0....2j1..gws-wiz.nh2EDUF3_BI&ved=0ahUKEwjYrs2BhILmAhVZfSsKHTvxAF8Q4dUDCAs&uact=5)" which the ecs-agent.log was telling us
* [Migrating your Amazon ECS deployment to the new ARN and resource ID format](https://aws.amazon.com/blogs/compute/migrating-your-amazon-ecs-deployment-to-the-new-arn-and-resource-id-format-2/)

### Troubleshooting

[ECS container instances not connected to the cluster](https://aws.amazon.com/premiumsupport/knowledge-center/ecs-agent-disconnected/)  
`systemctl status ecs` for the status of the ecs agent


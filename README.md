# Terraform-Wordpress-Website-AWS

In this project, I employed a robust suite of technologies to automate the creation of a secure and scalable WordPress blog site on AWS. Using Terraform and Packer, I automated the infrastructure setup and generated custom Amazon Machine Images (AMIs), respectively. I fortified the application's security with Snyk integrated into GitHub Actions, identifying and rectifying vulnerabilities in application dependencies. Amazon RDS was utilized for database management, storing user's posts in a MySQL instance.

To enhance security and operational insights, I incorporated Amazon Inspector for automated security assessments and CloudWatch Agent for comprehensive monitoring on the EC2 instances. I secured web traffic via an SSL certificate configured through AWS Certificate Manager, and employed Route 53 for domain management. Lastly, I introduced a CloudFront distribution in front of the application load balancer for improved site performance and security, establishing a resilient and performant WordPress website hosted on AWS.

## Application Breakdown

The application is broken down into the architecture below:

![wordpress](https://github.com/rjones18/Images/blob/main/AWS%20Wordpress%20Website%20(1).png)


Link to the 3 repos with Github Actions:

- [Infrastructure Pipeline](https://github.com/rjones18/AWS-WP-Infrastructure)
- [VPC Pipeline](https://github.com/rjones18/AWS-WP-VPC)
- [Database Pipeline](https://github.com/rjones18/AWS-WP-RDS)

Links to the AMI-Build Repo for this Project:

- [Packer AMI Build](https://github.com/rjones18/Wordpress-AMI-Build) (Currently being updated)


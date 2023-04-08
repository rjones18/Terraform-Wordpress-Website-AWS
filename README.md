# Terraform-Wordpress-Website-AWS

In this project, I leveraged several technologies to create a WordPress blog website in AWS. To automate the infrastructure setup, I utilized Terraform as the infrastructure-as-code tool to define the AWS resources needed to support the WordPress site. Next, I utilized Packer to create a custom Amazon Machine Image (AMI) with pre-installed packages using Ansible playbooks.

To store the user's posts, I deployed a MySQL database instance in Amazon RDS. Additionally, I integrated Route 53 to attach a custom domain name to the website and configured a Secure Sockets Layer (SSL) certificate via Certificate Manager for HTTPS encryption. All of these tools were orchestrated and deployed through GitHub Actions, a popular continuous integration and delivery platform. By using this technical stack, I was able to automate and streamline the entire deployment process, resulting in a scalable and secure WordPress website in AWS.

## Application Breakdown

The application is broken down into the architecture below:

![wordpress](https://github.com/rjones18/Images/blob/main/terraform-wordpress-project.png)



Links to the AMI-Build Repo for this Project:

- [Packer AMI Build](https://github.com/rjones18/Wordpress-AMI-Build)


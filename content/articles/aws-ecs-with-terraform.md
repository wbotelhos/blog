---
date: 2021-02-20T00:00:00-03:00
description: "AWS ECS With Terraform"
tags: ["aws", "amazon", "terraform", "ecs"]
title: "AWS ECS With Terraform"
---

Deploy sometimes can be a hard task, mainly if you do it directly in [AWS](https://aws.amazon.com). These days we have the facilitation to make the infrastructure versioned using tools like [Terraform](https://www.terraform.io), a tool that transforms API commands in a thing like a program code with a better nice syntax. Now with a tool to create the resources, we need to choose what kind of technology to use and you maybe have already heard about [Docker](https://www.docker.com) a way to run applications in a litter portion of your machine in an isolated way with no worries about different versions or types of applications.

## Goal

Setup a Rails application on AWS using ECS controlled by Terraform.

## Dependencies

- [AWS Cli](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- [Brew](https://brew.sh/index_pt-br)
- [tfenv](https://formulae.brew.sh/formula/tfenv)

And now you can install Terraform:

```sh
brew install tfenv
tfenv install 1.1.5 # use the last possible version
tfenv use 1.1.5
```

## Create the Terraform Project

Let's start creating a Git project, inside this project we can have as many Terraform projects as we want.

```sh
mkdir terraform
cd terraform
echo "# AWS ECS With Terraform" >> README.md
git init
git commit -A
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:wbotelhos/aws-ecs-with-terraform.git
git push -u origin main
```

## Initiate Terraform Workspace

You can isolate the configurations, like branches, to keep different states to different stages.

```sh
terraform init # initiate the project
terraform workspace new production # creates a production workspace
```

## Create Terraform Credentials

Since you can have more than one account on AWS is a good thing to make sure all commands will apply the change on the correct AWS account.

```sh
# aws.tf

provider "aws" {
  profile = "blog"
  region  = "us-east-1"
}
```

Now put your credentials inside the `~/.aws/credentials`:

```sh
[blog]
aws_access_key_id=...
aws_secret_access_key=...
```

Here I said to Terraform always use the profile `blog` at `us-east-1` and the credentials are located at `~/.aws/credentials`.

## Terraform Syntax

The syntax of Terraform is composed of a "method" with two arguments, the first one is the configured object and the second one is the name we give to this block of configuration. Most of the time it is irrelevant, we'll use the value `default`.


```sh
resource "aws_some_service" "variable_name" {
}
```

Here we're configuring the `some service` and the result of this block can be referred to in other resources through the name `variable_name` like `aws_some_service.variable_name.id`, getting the resulted ID of this block. Each resource can return different outputs.

## Create VPC

Our application is hosted on the internet but we can create our own "internet" inside AWS called [VPC](https://aws.amazon.com/pt/vpc) (Virtual Private Cloud). Everything inside it is protected from the internet (private) and we can make our own rule and decide who will have access to it.

```sh
# vpc.tf

resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Env  = "production"
    Name = "vpc"
  }
}
```

Here we have created a network `/16` that gives us IPs from `10.0.0.1` to `10.0.255.254` totalizing `65534` IPs. The `tags` are important to identify our resource and the `Name` is often presented on the AWS Panel, so at least provide it.

## Create Subnet

Inside our private network, we can separate groups of IP, this group can run isolated applications and in our case, we want two groups, one group that will have no access to the Internet (the world) and another one that will. Each of these groups will be divided into two parts. Let's create the public Subnet:

```sh
# subnet.public.tf

resource "aws_subnet" "public__a" {
  availability_zone       = "us-east-1a"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Env  = "production"
    Name = "public-us-east-1a"
  }

  vpc_id = aws_vpc.default.id
}

resource "aws_subnet" "public__b" {
  availability_zone       = "us-east-1b"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Env  = "production"
    Name = "public-us-east-1b"
  }

  vpc_id = aws_vpc.default.id
}
```

We set a public subnet at `us-east-1a` and another at `us-east-1b`, both will expose a public IP and both belong to the same VPC we created earlier. Since our VPC is `/16` we'll separate the IP `10.0.0.(0..255)` for Subnet Public A and `10.0.1.(0..255)` for Subnet Public B.

The Private Subnet will be very similar, but won't have a public IP:

```sh
# subnet.private.tf

resource "aws_subnet" "private__a" {
  availability_zone       = "us-east-1a"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false

  tags = {
    Env  = "production"
    Name = "private-us-east-1a"
  }

  vpc_id= aws_vpc.default.id
}

resource "aws_subnet" "private__b" {
  availability_zone       = "us-east-1b"
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = false

  tags = {
    Env  = "production"
    Name = "private-us-east-1b"
  }

  vpc_id= aws_vpc.default.id
}
```

This Subnet will be used, at `10.0.2.(0..255)` for Subnet Private A and `10.0.3.(0..255)` for Subnet Private B, to keep things like Database that does not need an Internet connection.

## Internet Gateway

Our Public Subnet will be public, so we need to have access to the Internet. To do it we create an Internet Gateway:

```sh
# internet_gateway.tf

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Env  = "production"
    Name = "internet-gateway"
  }
}
```

## Create Route Table

The Subnets are created, now we should create a route to these Subnets tracing a path for anyone that needs to reach it. We'll have one Public and one Private route:

```sh
# route_table.public.tf

resource "aws_route_table" "public" {
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Env  = "production"
    Name = "route-table-public"
  }

  vpc_id = aws_vpc.default.id
}

```

This Public Route binds all possible IPs to the Internet Gateway, so this route has a free path to the Internet and can be used to any resource that needs to be exposed to our final user.

```sh
# route_table.private.tf

resource "aws_route_table" "private" {
  tags = {
    Env  = "production"
    Name = "route-table-private"
  }

  vpc_id = aws_vpc.default.id
}
```

Our Private Route does not provide access to the Internet and is good to be used with internal resources like Database and so...

## Create Route Table Association

Now we have to connect the Route Table to the Subnets, finally tracing this communication path.

```sh
# route_table_association.public.tf

resource "aws_route_table_association" "public__a" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public__a.id
}

resource "aws_route_table_association" "public__b" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public__b.id
}
```

Both Public Subnets will use the Public Route Table.

```sh
# route_table_association.private.tf

resource "aws_route_table_association" "private__a" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private__a.id
}

resource "aws_route_table_association" "private__b" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private__b.id
}
```

And both Private Subnets will use the Private Route Table.

## Create Main Route Table Association

Our VPC comes with a default Main Route Table that will be in charge of be used by subnets without Route Table. Let's associate this default route to our Public Route Table:

```sh
# main_route_table_association.tf

resource "aws_main_route_table_association" "default" {
  route_table_id = aws_route_table.public.id
  vpc_id         = aws_vpc.default.id
}
```

For now, we could create everything about our VPC and the way communication works inside it. Good job! (:

## Create Database Instance on RDS

AWS already gives us a complete database via the RDS service, although you'll pay one more EC2 for it. Before the DB let's create a Security Group for it:

```sh
# security_group.db_instance.tf

resource "aws_security_group" "db_instance" {
  description = "security-group--db-instance"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 5432
    protocol    = "tcp"
    to_port     = 5432
  }

  name = "security-group--db-instance"

  tags = {
    Env  = "production"
    Name = "security-group--db-instance"
  }

  vpc_id = aws_vpc.default.id
}
```

This Security Group opens ingress for the port `5432` and all traffic to outside.

## Create DB Subnet Group

Our Database needs a Subnet to run and in this case, since we do not have external access, it will be on the Private Subnet.

```sh
# db_subnet_group.tf

resource "aws_db_subnet_group" "default" {
  name = "db-subnet-group"

  subnet_ids = [
    aws_subnet.private__a.id,
    aws_subnet.private__b.id
  ]

  tags = {
    Env  = "production"
    Name = "db-subnet-group"
  }
}
```

## Create DB Instance

And finally, we can create our Database.

```sh
resource "aws_db_instance" "default" {
  backup_window             = "03:00-04:00"
  ca_cert_identifier        = "rds-ca-2019"
  db_subnet_group_name      = "db-subnet-group"
  engine_version            = "13.4"
  engine                    = "postgres"
  final_snapshot_identifier = "final-snapshot"
  identifier                = "production"
  instance_class            = "db.t3.micro"
  maintenance_window        = "sun:08:00-sun:09:00"
  name                      = "blog_production"
  parameter_group_name      = "default.postgres13"
  password                  = "YOUR-MASTER-PASSWORD"
  username                  = "postgres"
}
```

Here is used the name of the Subnet Group instead of an ID. We need to choose the default Certificate and the other attributes are simple to understand.
For Database, it is enough and now we enter in some more complex configuration about ALB and EC2.

## Create Security Group ALB

We'll accept only HTTP connections from the internet and can have all traffic out.

```sh
# security_group.alb.tf

resource "aws_security_group" "alb" {
  description = "security-group--alb"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  name = "security-group--alb"

  tags = {
    Env  = "production"
    Name = "security-group--alb"
  }

  vpc_id = aws_vpc.default.id
}
```

## Create ALB

ALB is very important because with it we can scale up or down the application and have one single point of access.

```sh
# alb.tf

resource "aws_alb" "default" {
  name            = "alb"
  security_groups = [aws_security_group.alb.id]

  subnets = [
    aws_subnet.public__a.id,
    aws_subnet.public__b.id,
  ]
}
```

The ALB stays at Public Subnet since it needs to be exposed to the internet and it'll use the created security group allowing the access.

## Create ALB Target Group

Target Group is the way we control the traffic from the ALB to the application, soon we'll route the connection to this group.

```sh
# alb_target_group.tf

resource "aws_alb_target_group" "default" {
  health_check {
    path = "/"
  }

  name     = "alb-target-group"
  port     = 80
  protocol = "HTTP"

  stickiness {
    type = "lb_cookie"
  }

  vpc_id = aws_vpc.default.id
}
```

The Load Balance will act when the route `/` does not return ok.

> If you're using Socket, for example, you need to make sure all connections go to the same group, in this case, use the `stickiness { type = "lb_cookie" }` to stick the session and avoid Round Robin that will normally send the connection to some instance with less process.

## Create Security Group EC2

Our EC2 Instance should be reached only via the ALB connection, so we can just allow all connections coming from it to refer to the ALB Security Group. All output traffic is allowed.

```sh
# security_group.ecs.tf

resource "aws_security_group" "ec2" {
  description = "security-group--ec2"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    from_port       = 0
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
    to_port         = 65535
  }

  name = "security-group--ec2"

  tags = {
    Env  = "production"
    Name = "security-group--ec2"
  }

  vpc_id = aws_vpc.default.id
}
```

## Create IAM Policy Document

Here we start to create the rules to be applied to the EC2 machine to deal with ECS and we start with a policy:

```sh
# iam_policy_document.ecs.tf

data "aws_iam_policy_document" "ecs" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}
```

## Create IAM Role

This previous policy allows an EC2 to assume, temporally, a role as the following:

```sh
# iam_role.ecs.tf

resource "aws_iam_role" "ecs" {
  assume_role_policy = data.aws_iam_policy_document.ecs.json
  name               = "ecsInstanceRole"
}
```

Now we have a Role called `ecsInstanceRole` which an EC2 can use to receive some *powers*.


## Create IAM Role Policy Attachment

The Role previously created has no permission yet, so now we'll attach some:

```sh
# iam_role_policy_attachment.ecs.tf

resource "aws_iam_role_policy_attachment" "ecs" {
  role       = aws_iam_role.ecs.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
```

The Policy `AmazonEC2ContainerServiceforEC2Role` already exists on AWS, so we don't need to create it from the scratch. It'll give access to resources that ECS needs to deal with to run the application.


## IAM Instance Profile

Now we have the Role with the necessary Policies and this Role can be used by the Instance Profile. The Instance Profile identifies the EC2, so it assumes the given role.

```sh
# iam_instance_profile.ecs.tf

resource "aws_iam_instance_profile" "ecs" {
  name = "ecsInstanceProfile"
  role = aws_iam_role.ecs.name
}
```

Heads up! If you create the Role via AWS Panel, the Role and the Instance Role will be created at the same time with the same name, but since we're creating it separated, we can name it differently.

## Create AMI

All EC2 comes from an image called AMI (Amazon Machine Images). In our case, we need an image compatible with ECS/Docker so we need to choose the right image and if possible, always the latest updated image.
Some people used to use the AMI (`ami-23fd8d1g23faz...`) name directly on the Terraform code, it works, but if that AMI updates, you won't get the last version.

```sh
# ami.tf

data "aws_ami" "default" {
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.202*-x86_64-ebs"]
  }

  most_recent = true
  owners      = ["amazon"]
}
```

We use `filter` to find the AMI we want and with wildcard, we can get all Amazon ECS images `2.0` from the year `202...` (`2022-01-01`). Then we say we always want the most recent version from all results returned for us. :)

## Create User Data

Every time an EC2 instance starts we can run a custom code, this code is called User Data. A trick thing to do here is to make sure that our EC2 is shown up on the right ECS cluster we'll create, for this we need to indicate it as an ENV variable. Really, many people including me lost a lot of hair to discover it, so, it won't happen to you.

```sh
# user_data.sh

#!/bin/bash

echo ECS_CLUSTER=production >> /etc/ecs/ecs.config
```

In the future, our cluster will call `production`.

## Create Key Pair

When we launch an EC2 we need to provide a Key Pair as authentication to have access to the instance, let's create it:

```sh
  KEY_PATH=~/.ssh/blog
  EMAIL=contact@blog.com

  ssh-keygen -t rsa -b 4096 -f $KEY_PATH -C $EMAIL
  # Enter passphrase (empty for no passphrase): press Enter
  # Enter same passphrase again: press Enter
  chmod 600 $KEY_PATH
  ssh-add $KEY_PATH
  cat ${KEY_PATH}.pub
```

Copy the public key output and paste it on the following `public_key` attribute:

```sh
# key_pair.tf

resource "aws_key_pair" "default" {
  key_name   = "blog"
  public_key = "ssh-rsa AAA...agw== contact@blog.com"

  tags = {
    "Name" = "contact@blog.com"
  }
}
```

Unfortunately, you can't use the `file` function to read a file content, so it needed to be inline.

## Create Launch Configuration

This configuration will indicate the EC2 config and it is used by the Auto Scale to boot up new machines.

```sh
# launch_configuration.tf

resource "aws_launch_configuration" "default" {
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ecs.name
  image_id                    = data.aws_ami.default.id
  instance_type               = "t3.micro"
  key_name                    = "blog"

  lifecycle {
    create_before_destroy = true
  }

  name_prefix = "lauch-configuration-"

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  security_groups = [aws_security_group.ec2.id]
  user_data       = file("user_data.sh")
```

- We want a public IP to be possible login to this instance;
- This machine will self identify with the `ecsInstanceProfile` we've created;
- The AMI used is that one we've filtered;
- You need to provide the name of the Key Pair created, only this key can access the EC2;
- The `lifecycle` is important to be provided together with the `name_prefix`, in this way the Auto Scale can create a new Launch Configuration without conflict when you need to do some update and will remove the current resource only when creating the new one, making the changes smooth;
- The HD will have `30G` and use an `SSD` `GP2`;
- Here we attach the Security Group created previously;

And finally, the trick part, you should provide user data, a code that will be triggered when the instance starts:

```sh
#!/bin/bash

echo ECS_CLUSTER=production >> /etc/ecs/ecs.config
```

It'll indicate which ECS Cluster this machine will be available, without it, the container won't find an instance and your task will fail. We'll see it soon.

## Create ALB Listener

Our Load Balancer is ready, but still not hearing anything, here will make it happen.

```sh
# alb_listener.tf

resource "aws_alb_listener" "default" {
  default_action {
    target_group_arn = aws_alb_target_group.default.arn
    type             = "forward"
  }

  load_balancer_arn = aws_alb.default.arn
  port              = 80
  protocol          = "HTTP"
}
```

Here we're forwarding all traffic from the ALB to the Target Group. If you access the Load Balance's DNS you should see a `5xx` code.

> Heads up! A good practice is to use an SSL certificate on ALB, but I'll use HTTP to avoid a bigger article, but soon I'll explain how to configure HTTPS with ACM and Cloudflare.

## Create Autoscaling Group

Now with everything configured we can decide how we'll scale the things.

```sh
# autoscaling_group.tf

resource "aws_autoscaling_group" "default" {
  desired_capacity     = 1
  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.default.name
  max_size             = 2
  min_size             = 1
  name                 = "auto-scaling-group"

  tag {
    key                 = "Env"
    propagate_at_launch = true
    value               = "production"
  }

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "blog"
  }

  target_group_arns    = [aws_alb_target_group.default.arn]
  termination_policies = ["OldestInstance"]

  vpc_zone_identifier = [
    aws_subnet.public__a.id,
    aws_subnet.public__b.id
  ]
}
```

- We want a minimum of 1 instance running and a maximum of 2 but the `desired_capacity` will dictate how many instances will be run. This value can be changed by the Load Balance and stay between `min_size` and `max_size`;
- Our Health Check is done on EC2;
- This Group will use our previous Launch Configuration to know about the EC2 config;
- The tags will propagate their value to the EC2 instance, so we can check who is in charge to run which one;
- Remember we need to traffic the connections to a Target Group, well it's here;
- Every time we scale down we'll terminate the oldest instance since AWS charges the hour on the first seconds and we want to take the advantage of the most time we have;
- This traffic will pass through the Public Subnet.

## Create ECR Repository

Our Docker image can be hosted in the AWS ECR, so during the deploy will fetch it.

```sh
# ecr_repository.tf

resource "aws_ecr_repository" "default" {
  name = "blog"

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "repository_url" {
  value = aws_ecr_repository.default.repository_url
}
```

We configured an auto-scan on push. It helps us discover a vulnerability in the image.
The `output` command will expose the repository URL, we want to save the account id and the region for later.

## Create App

Let's create a simple Sinatra Application to be used as an Image using Sinatra:

```rb
# Gemfile

source 'https://rubygems.org'

gem 'sinatra'
```

It responds to the root URL returning a message.

```rb
# app.rb

class App < Sinatra::Base
  get "/" do
    ENV.fetch("MESSAGE", "Message ENV missing.")
  end
end
```

Now we need to create a Rack Configuration File:

```rb
# config.ru

require "bundler"

Bundler.require

require_relative "app.rb"

run App
```

It runs bundler and then runs the App file with the route. It's necessary a Dockerfile build the app image:

```dockerfile
# Dockerfile

FROM ruby:2.7.4-alpine

WORKDIR /var/www/app

COPY Gemfile* ./

RUN gem install bundler
RUN bundle install

COPY . /var/www/app

CMD ["bundle", "exec", "rackup", "-p", "8080", "-E", "production"]
```

This Dockerfile installs Ruby, puts the files into `/var/www/app`, and runs Rack as production.
Now we'll build the image and upload it to ECR, but let's test the app:

```sh
docker build . -t blog
docker run -it -p 8080:8080 blog
open http://localhost:8080 # in a new tab
```

## Create ECR Release File

Here we'll create a file responsible to make the releases, it'll receive ENV variables.

```sh
# release.sh

#!/bin/bash

ECR_URL=${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com

aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ECR_URL}

REPOSITORY=${REPOSITORY}

docker build . -t ${REPOSITORY}:${TAG} \
  --build-arg MESSAGE=${MESSAGE}

docker tag ${REPOSITORY}:${TAG} ${ECR_URL}/${REPOSITORY}:${TAG}
docker push ${ECR_URL}/${REPOSITORY}:${TAG}
```

We build the ECR URL and execute the login on it, after we build the image, set the tag, and push it to the repository.
Now make this file executable with: `chmod +x release.sh` and then run it passing some variables including that extracted from the ECR output.

```sh
ACCOUNT_ID=... \
AWS_PROFILE=blog \
REGION=us-east-1 \
REPOSITORY=blog \
TAG=v0.1.0 \
../terraform/release.sh
```

> Heads up! The ENV `AWS_PROFILE` is important if you have more than one AWS profile configured.

## Create ECS Cluster

Finally, let's create our ECS Cluster.

```sh
# ecs_cluster.tf

resource "aws_ecs_cluster" "production" {
  lifecycle {
    create_before_destroy = true
  }

  name = "production"

  tags = {
    Env  = "production"
    Name = "production"
  }
}
```

The Cluster groups a couple of Service and we can separate Stages by Clusters, for example.

## Create Container Definitions

It's a JSON file containing the definitions of our container and you can consider it as our boot-up config, like the Dockerfile.

```sh
# container_definitions.json

[{
  "command": ["bundle", "exec", "rackup", "-p", "8080", "-E", "production"],
  "cpu": 1024,

  "environment": [
    { "name": "MESSAGE", "value": "Hello World!" }
  ],

  "image": "ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/blog:v0.1.0",
  "name": "app",

  "portMappings": [
    { "containerPort": 8080, "protocol": "tcp" }
  ]
}]
```

- We have the same Dockerfile command to run the application;
- We're using `1024` CPU units to run this task;
- The ENVs are provided here and exported;
- The image is the repository URL output from ECR Resource plus the tag version you want;
- The app name will be `app`;
- Our app will listen on container port `8080`.

## Create Task Definition

It creates the Task Definition using the Container Definition we've just created. Each time you need a deploy you'll need a new Task Definition version where it can change the ECR image or just configurations like ENV or container settings.

```sh
# ecs_task_definition.tf

resource "aws_ecs_task_definition" "default" {
  container_definitions    = file("container_definitions.json")
  family                   = "blog"
  memory                   = 500
  network_mode             = "host"
  requires_compatibilities = ["EC2"]
}
```

- The `family` is the name of the Task Definition;
- The configuration of the container is kept as a JSON;
- The memory will be 500 MiB (1 MiB = 2^20 bytes = 1,048,576 bytes);
- The network is `host` for better performance. If you need to run multiple tasks from the same app into the same container, use `bridge` instead;
- We're a launch type as EC2 over Fargate.

## Create Task Definition Data

For deployment purposes, we can create a data resource just to fetch the latest active task definition revision.

```sh
# ecs_task_definition.data.tf

data "aws_ecs_task_definition" "default" {
  task_definition = aws_ecs_task_definition.default.family
}
```

## Create ECS Service

The Service could be represented as your application, so it can be your Rails app or your database. In our case, it's the Sinatra app running.

```sh
# ecs_service.tf

resource "aws_ecs_service" "default" {
  cluster                 = aws_ecs_cluster.production.id
  depends_on              = [aws_iam_role_policy_attachment.ecs]
  desired_count           = 1
  enable_ecs_managed_tags = true
  force_new_deployment    = true

  load_balancer {
    target_group_arn = aws_alb_target_group.default.arn
    container_name   = "app"
    container_port   = 8080
  }

  name            = "blog"
  task_definition = "${aws_ecs_task_definition.default.family}:${data.aws_ecs_task_definition.default.revision}"
}
```

- This service will run on cluster production;
- The `depends_on` is a recommendation to avoid the IAM policy be removed before the service, in update/destroy cases, and then this action hangs forever;
- We desire to have 1 instance of the Task (clone of your app) running;
- We want AWS to create tags on the Tasks, these tags indicate the Cluster and the Service and are very helpful;
- The deployment will be forced, but you can configure the strategy to replace containers during the deployment;
- We attach the Load Balance to the Service, so Load Balance can distribute the requests between the Tasks. It'll be bound on the `containerPort` defined previously;
- Our app service will be called `blog`;
- And the trick is to refer to the task definition getting the last revision.

## Accessing The App

Congratulations! You made all the necessary setup, now just run `terraform apply` and wait until everything is done.
To access the app, go to the [ALB page](https://us-east-1.console.aws.amazon.com/ec2/v2/home?region=us-east-1#LoadBalancers:sort=loadBalancerName) and get the **DNS name** to access via browser.

## Using Variables

We can use a variable to facilitate our life the syntax is `${variable}` and before we use it we need to declare it.
For `.tf` files you just call `var.variable`, but for JSON files you need to use a template. For a complete example let's pass the `MESSAGE` ENV from `container_definition.json` as a variable, so let's create a file to declare this variable.

```sh
# container_definitions.json.variables.tf

variable "container_definitions__message" { default = "Hello World!" }
```

I like to create a variable file for each resource since I used to create a file per resource. I like the name of the variable composed of `resource_name` + `__` + `variable_name`, but feel free to use in your way.
The variable can have a default and if you want other attributes like `description`.

Change the `container_definition.json` to use a key over the message value:

```sh
# container_definitions.json

{ "name": "MESSAGE", "value": "${message}" }
```

And now we need to create a template file responsible to merge the variables to the JSON treated as a template:

```sh
# container_definitions.json.template.tf

data "template_file" "container_definitions" {
  template = file("container_definitions.json")

  vars = {
    message = var.container_definitions__message
  }
}
```

Here we loaded the JSON file and merged the `vars` composed by the key used inside the template and the value fetched from the variable declared previously.

# Using Variables Per Stage

The variable `message` is a default value and maybe works very well for static values, but the most of time we want to declare different values based on the stage, for that we can create a var file and use it on the `apply` command.

```sh
# production.tfvars

container_definitions__message="World, Hello!"
```

Now we just refer it:

```sh
terraform apply -var-file="stages/production.tfvars"
```

Here you can have as many files as your stages, but if your data is sensitive data?

## Using Parameter Store

Sensitive data shouldn't be committed in the repository and AWS has a good place to keep it, the [SSM Parameter](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ssm-parameter.html). To fetch it, first we need to set these values there, you can do it manually or via Terraform, let's use the last one option.

```sh
# ssm_parameter.tf

resource "aws_ssm_parameter" "container_definitions__account_id" {
  name  = "/terraform/${terraform.workspace}/CONTAINER_DEFINITIONS__ACCOUNT_ID"
  type  = "String"
  value = "YOUR-ACCOUNT-ID"
}

resource "aws_ssm_parameter" "db_instance__password" {
  name  = "/terraform/${terraform.workspace}/DB_INSTANCE__PASSWORD"
  type  = "SecureString"
  value = "YOUR-PASSWORD"
}

resource "aws_ssm_parameter" "key_pair__public_key" {
  name  = "/terraform/${terraform.workspace}/KEY_PAIR__PUBLIC_KEY"
  type  = "SecureString"
  value = "YOUR-PUBLIC-KEY-PAIR"
}
```

Here we used a variable from Terraform called `workspace`. It was set at the beginning of this article when we create the workspace.
This file is just to help you to create the entries, but it won't be committed, so add it to the `.gitignore`:

```sh
echo 'ssm_parameter.tf' >> .gitignore
```

Now we'll use the values as data:

```sh
# ssm_parameter.data.tf

data "aws_ssm_parameter" "container_definitions__account_id" {
  name  = "/terraform/${terraform.workspace}/CONTAINER_DEFINITIONS__ACCOUNT_ID"
}

data "aws_ssm_parameter" "db_instance__password" {
  name  = "/terraform/${terraform.workspace}/DB_INSTANCE__PASSWORD"
}

data "aws_ssm_parameter" "key_pair__public_key" {
  name  = "/terraform/${terraform.workspace}/KEY_PAIR__PUBLIC_KEY"
}
```

Just replace the static values with the dynamic values from SSM:


```sh
# container_definitions.json.template.tf

account_id = data.aws_ssm_parameter.container_definitions__account_id.value
```

```sh
# container_definitions.tf

"image": "${account_id}.dkr.ecr.us-east-1.amazonaws.com/blog:v0.1.0",
```

```sh
# db_instance.tf

password = data.aws_ssm_parameter.db_instance__password.value
```

```sh
# key_pair.tf

public_key = data.aws_ssm_parameter.key_pair__public_key.value
```

```sh
# launch_configuration.tf

iam_instance_profile = "arn:aws:iam::${data.aws_ssm_parameter.container_definitions__account_id.value}:instance-profile/ecsInstanceProfile"
```

Now everything is on SSM Parameter and you can create an SH script to update this and then run the terraform apply or if your CI/CD is not so modern like this, make the change directly on AWS using the AWS CLI.

## Conclusion

Although we can improve this code using modules, that's it!
I'm not an expert in Infrastructure so feel free to help me to improve this code, I'll be very happy to learn new things.
Leave your comment and let me know what you think about this subject.

Repository link: [https://github.com/wbotelhos/aws-ecs-with-terraform](https://github.com/wbotelhos/aws-ecs-with-terraform)

Thank you! (:

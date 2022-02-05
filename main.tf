module "vpc" {
  source = "./modules/vpc"

  cidr_block           = "10.0.0.0/16"
  enable_dhcp_options  = var.enable_dhcp_options
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(local.common_tags,
  { Name = "main-vpc" })
  tags_for_resource = var.tags_for_resource
}

resource "aws_route" "rtb" {
  count = 1

  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = element(module.public_subnets.route_table_ids, count.index)
  gateway_id             = module.vpc.internet_gateway_id
}


module "public_subnets" {
  source = "./modules/subnets"

  vpc_id                  = module.vpc.vpc_id
  gateway_id              = module.vpc.internet_gateway_id
  map_public_ip_on_launch = true

  cidr_block         = "10.0.0.0/26"
  subnet_count       = "1"
  availability_zones = ["us-east-1a"]

  tags = merge(local.common_tags,
  { Name = "main-subnet" })
  tags_for_resource = var.tags_for_resource
}

module "private_subnets" {
  source = "./modules/subnets"

  vpc_id                  = module.vpc.vpc_id
  gateway_id              = module.vpc.internet_gateway_id
  map_public_ip_on_launch = false

  cidr_block         = "10.0.1.0/26"
  subnet_count       = "1"
  availability_zones = ["us-east-1a"]

  tags = merge(local.common_tags,
  { Name = "main-subnet" })
  tags_for_resource = var.tags_for_resource
}

module "sg" {
  source          = "./modules/sg"
  security_groups = true
  vpc_id          = module.vpc.vpc_id

  sg_name = join("-", [local.app.app_type, "sg"])
  sg_ingresss = [{
    description = "security group that allows ssh and all ingress traffic"
    cidr_blocks = "0.0.0.0/0"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    self        = false
    },
    {
      description = "security group that allows ssh and all ingress traffic"
      cidr_blocks = "0.0.0.0/0"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      self        = false
    }
  ]
  sg_egresss = [{
    description = "security group that allows ssh and all engress traffic"
    cidr_blocks = "0.0.0.0/0"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }]

  tags = local.common_tags
}
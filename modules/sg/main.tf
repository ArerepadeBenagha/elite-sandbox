resource "aws_default_security_group" "sg" {
  count = var.create_vpc && var.security_groups ? 1 : 0

  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.sg_ingresss
    content {

      self            = lookup(ingress.value, "self", null)
      cidr_blocks     = compact(split(",", lookup(ingress.value, "cidr_blocks", "")))
      security_groups = compact(split(",", lookup(ingress.value, "security_groups", "")))
      description     = lookup(ingress.value, "description", null)
      from_port       = lookup(ingress.value, "from_port", 0)
      to_port         = lookup(ingress.value, "to_port", 0)
      protocol        = lookup(ingress.value, "protocol", "-1")
    }
  }

  dynamic "egress" {
    for_each = var.sg_egresss
    content {
      self            = lookup(egress.value, "self", null)
      cidr_blocks     = compact(split(",", lookup(egress.value, "cidr_blocks", "")))
      security_groups = compact(split(",", lookup(egress.value, "security_groups", "")))
      description     = lookup(egress.value, "description", null)
      from_port       = lookup(egress.value, "from_port", 0)
      to_port         = lookup(egress.value, "to_port", 0)
      protocol        = lookup(egress.value, "protocol", "-1")
    }
  }

  tags = merge(
    {
      "Name" = format("%s", var.sg_name)
    },
    var.tags
  )
}
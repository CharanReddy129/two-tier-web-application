variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "tags" {
  type = map(string)
  default = {
    "terraform"  = "true"
    "kubernetes" = "demo-eks-cluster"
  }
}

variable "eks-version" {
  type    = string
  default = "1.31"
}

variable "cluster_name" {
  type    = string
  default = "demo-eks-cluster"
}
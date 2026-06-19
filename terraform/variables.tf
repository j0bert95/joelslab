variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-east1"
}

variable "zone" {
  type    = string
  default = "us-east1-c"
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR range for the subad1 subnet."
  default     = "10.10.1.0/24"
}

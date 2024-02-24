variable "name" {
  description = "ECR name"
}

variable "image_tag_mutability" {
  description = "Tag mutability for ECR"
  default = "MUTABLE"
}

variable "scan_on_push" {
  description = "Boolean to set image scan on push"
  default = true
}
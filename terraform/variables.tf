
variable "gcp_key" {
  description = "value of the GCP key"
  type = string
}

variable "ssh_user" {
  description = "SSH user"
  type = string
}

variable "ssh_key" {
  description = "SSH key"
  type = string
}

variable "backup" {
  description = "Backup the instance"
  type = bool
  default = false
}

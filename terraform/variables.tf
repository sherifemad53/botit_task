variable "repo_name" {
  default = "sherifemad53/botit_task"
}

variable "ssh_public_key" {
  description = "Public key for SSH access"
  type        = string
  # Default provided for example; in real usage pass this via -var or TF_VAR_
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC..."
}

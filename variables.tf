variable "registry_server" {
  type    = string
  default = "docker.pkg.github.com"
}

variable "registry_username" {
  type    = string
  default = "paretl"
}

variable "registry_password" {
  type    = string
}

variable "logzio_token" {
  type    = string
}

variable "slack_api_url" {
  type    = string
}

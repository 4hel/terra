variable "http_port" {
  description = "http port"
  default = 8080
}

variable "env" {
  description = "the environment stage or prod"
}

variable "db_remote_state_bucket" {
  description = "the name of the s3 bucket for the database's remote state"
}

variable "db_remote_state_key" {
  description = "the path for the database's remote state in s3"
}

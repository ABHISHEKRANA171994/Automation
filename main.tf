provider "github" {
  token        = var.github_token
  organization = var.github_organization
}

resource "github_repository" "new_repos" {
  count        = length(local.repo_names)
  name         = local.repo_names[count.index]
  visibility   = "private"  # Use "private" for non-Enterprise GitHub organizations
  description  = "Repository created via Terraform. This repository is used for automated and consistent creation of repositories."
  auto_init    = true
}

variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
}

variable "github_organization" {
  description = "GitHub Organization Name"
  type        = string
}

variable "emails" {
  description = "List of email addresses to derive repository names"
  type        = list(string)
}

variable "repo_count_per_email" {
  description = "Number of repositories to create per email"
  type        = number
  default     = 1
}

locals {
  # Generate a unique date in DD-MM-YY format
  formatted_date = formatdate("02-01-06", timestamp())

  # Generate repository names based on email addresses and count
  repo_names = flatten([
    for email in var.emails : [
      for i in range(var.repo_count_per_email) : "TEST_${replace(split("@", email)[0], ".", "_")}_${local.formatted_date}_${i + 1}"
    ]
  ])
}

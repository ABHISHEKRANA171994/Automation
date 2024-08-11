provider "github" {
  token = var.github_token
}

# Define a list of repository names
variable "repo_names" {
  description = "List of repository names to create."
  type        = list(string)
}

resource "github_repository" "example" {
  count       = length(var.repo_names)
  name        = var.repo_names[count.index]
  description = "This is a dynamically created repository."
  private     = false
}

variable "github_token" {
  description = "The GitHub personal access token."
  type        = string
}

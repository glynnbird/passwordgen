# Basic project
resource "cloudflare_pages_project" "frontend_project" {
  account_id        = var.cloudflare_account_id
  name              = "pass"
  production_branch = "cf"
  
  build_config {
    destination_dir     = "dist"
    root_dir            = "/"
  }

  source {
    type = "github"
    config {
      owner                         = "glynnbird"
      repo_name                     = "passwordgen"
      production_branch             = "cf"
    }
  }
    deployment_configs {
      preview {
        
      }
      production {
        environment_variables = {
          NODE_VERSION = "20"
        }
      }
  }
}

resource "cloudflare_pages_domain" "frontend_domain" {
  account_id   = var.cloudflare_account_id
  project_name = cloudflare_pages_project.frontend_project.name
  domain       = var.cloudflare_domain
}

resource "cloudflare_record" "frontend_dns" {
  zone_id = var.cloudflare_zone_id
  name    = "pass"
  content   = cloudflare_pages_project.frontend_project.subdomain
  type    = "CNAME"
  ttl     = 3600
}

## Container repositories for the GIS stack
# Geoweb containers - a DLS-managed Ruby-on-Rails application that is dockerized
# This is a standard ECR for an ECS with a Fargate launch type
module "ecr_geoweb" {
  source            = "./modules/ecr"
  repo_name         = "geoweb"
  login_policy_arn  = aws_iam_policy.login.arn
  oidc_arn          = data.aws_ssm_parameter.oidc_arn.value
  environment       = var.environment
  tfoutput_ssm_path = var.tfoutput_ssm_path
  tags = {
    app-repo   = "geoweb"
    project-id = "gis-services"
  }
}

# GeoServer containers - a modification of the official GeoServer Docker container
# This is a standard ECR for an ECS with a Fargate launch type
module "ecr_geoserver" {
  source            = "./modules/ecr"
  repo_name         = "docker-geoserver"
  login_policy_arn  = aws_iam_policy.login.arn
  oidc_arn          = data.aws_ssm_parameter.oidc_arn.value
  environment       = var.environment
  tfoutput_ssm_path = var.tfoutput_ssm_path
  tags = {
    app-repo   = "docker-geoserver"
    project-id = "gis-services"
  }
}

# GeoSolr containers - a modification of the official Solr Docker container
# This is a standard ECR for an ECS with a Fargate launch type
module "ecr_geosolr" {
  source            = "./modules/ecr"
  repo_name         = "docker-geosolr"
  login_policy_arn  = aws_iam_policy.login.arn
  oidc_arn          = data.aws_ssm_parameter.oidc_arn.value
  environment       = var.environment
  tfoutput_ssm_path = var.tfoutput_ssm_path
  tags = {
    app-repo   = "docker-geosolr"
    project-id = "gis-services"
  }
}

# Slingshot containers - a DLS-managed Python application that is dockerized
# This is a standard ECR for an ECS with a Fargate launch type
module "ecr_slingshot" {
  source            = "./modules/ecr"
  repo_name         = "slingshot"
  login_policy_arn  = aws_iam_policy.login.arn
  oidc_arn          = data.aws_ssm_parameter.oidc_arn.value
  environment       = var.environment
  tfoutput_ssm_path = var.tfoutput_ssm_path
  tags = {
    app-repo   = "slingshot"
    project-id = "gis-services"
  }
}

## Outputs to Terraform Cloud for devs ##

## For geoweb application repo and ECR repository
# Outputs in dev
output "geoweb_fargate_dev_build_workflow" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/fargate-dev-build.tpl", {
    region = var.aws_region
    role   = module.ecr_geoweb.gha_role
    ecr    = module.ecr_geoweb.repository_name
    }
  )
  description = "Full contents of the dev-build.yml for the geoweb-deposits repo"
}
output "geoweb_fargate_makefile" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/fargate-makefile.tpl", {
    ecr_name = module.ecr_geoweb.repository_name
    ecr_url  = module.ecr_geoweb.repository_url
    }
  )
  description = "Full contents of the Makefile for the geoweb-deposits repo (allows devs to push to Dev account only)"
}

# Outputs in stage
output "geoweb_fargate_stage_build_workflow" {
  value = var.environment == "prod" || var.environment == "dev" ? null : templatefile("${path.module}/files/fargate-stage-build.tpl", {
    region = var.aws_region
    role   = module.ecr_geoweb.gha_role
    ecr    = module.ecr_geoweb.repository_name
    }
  )
  description = "Full contents of the stage-build.yml for the geoweb-deposits repo"
}

# Outputs after promotion to prod
output "geoweb_fargate_prod_promote_workflow" {
  value = var.environment == "stage" || var.environment == "dev" ? null : templatefile("${path.module}/files/fargate-prod-promote.tpl", {
    region     = var.aws_region
    role_stage = "${module.ecr_geoweb.repo_name}-gha-stage"
    role_prod  = "${module.ecr_geoweb.repo_name}-gha-prod"
    ecr_stage  = "${module.ecr_geoweb.repo_name}-stage"
    ecr_prod   = "${module.ecr_geoweb.repo_name}-prod"
    }
  )
  description = "Full contents of the prod-promote.yml for the geoweb-deposits repo"
}

## For geoserver application repo and ECR repository
# Outputs in dev
output "geoserver_fargate_dev_build_workflow" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/fargate-dev-build.tpl", {
    region = var.aws_region
    role   = module.ecr_geoserver.gha_role
    ecr    = module.ecr_geoserver.repository_name
    }
  )
  description = "Full contents of the dev-build.yml for the geoserver-deposits repo"
}
output "geoserver_fargate_makefile" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/fargate-makefile.tpl", {
    ecr_name = module.ecr_geoserver.repository_name
    ecr_url  = module.ecr_geoserver.repository_url
    }
  )
  description = "Full contents of the Makefile for the geoserver-deposits repo (allows devs to push to Dev account only)"
}

# Outputs in stage
output "geoserver_fargate_stage_build_workflow" {
  value = var.environment == "prod" || var.environment == "dev" ? null : templatefile("${path.module}/files/fargate-stage-build.tpl", {
    region = var.aws_region
    role   = module.ecr_geoserver.gha_role
    ecr    = module.ecr_geoserver.repository_name
    }
  )
  description = "Full contents of the stage-build.yml for the geoserver-deposits repo"
}

# Outputs after promotion to prod
output "geoserver_fargate_prod_promote_workflow" {
  value = var.environment == "stage" || var.environment == "dev" ? null : templatefile("${path.module}/files/fargate-prod-promote.tpl", {
    region     = var.aws_region
    role_stage = "${module.ecr_geoserver.repo_name}-gha-stage"
    role_prod  = "${module.ecr_geoserver.repo_name}-gha-prod"
    ecr_stage  = "${module.ecr_geoserver.repo_name}-stage"
    ecr_prod   = "${module.ecr_geoserver.repo_name}-prod"
    }
  )
  description = "Full contents of the prod-promote.yml for the geoserver-deposits repo"
}

## For geosolr application repo and ECR repository
# Outputs in dev
output "geosolr_fargate_dev_build_workflow" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/fargate-dev-build.tpl", {
    region = var.aws_region
    role   = module.ecr_geosolr.gha_role
    ecr    = module.ecr_geosolr.repository_name
    }
  )
  description = "Full contents of the dev-build.yml for the geosolr-deposits repo"
}
output "geosolr_fargate_makefile" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/fargate-makefile.tpl", {
    ecr_name = module.ecr_geosolr.repository_name
    ecr_url  = module.ecr_geosolr.repository_url
    }
  )
  description = "Full contents of the Makefile for the geosolr-deposits repo (allows devs to push to Dev account only)"
}

# Outputs in stage
output "geosolr_fargate_stage_build_workflow" {
  value = var.environment == "prod" || var.environment == "dev" ? null : templatefile("${path.module}/files/fargate-stage-build.tpl", {
    region = var.aws_region
    role   = module.ecr_geosolr.gha_role
    ecr    = module.ecr_geosolr.repository_name
    }
  )
  description = "Full contents of the stage-build.yml for the geosolr-deposits repo"
}

# Outputs after promotion to prod
output "geosolr_fargate_prod_promote_workflow" {
  value = var.environment == "stage" || var.environment == "dev" ? null : templatefile("${path.module}/files/fargate-prod-promote.tpl", {
    region     = var.aws_region
    role_stage = "${module.ecr_geosolr.repo_name}-gha-stage"
    role_prod  = "${module.ecr_geosolr.repo_name}-gha-prod"
    ecr_stage  = "${module.ecr_geosolr.repo_name}-stage"
    ecr_prod   = "${module.ecr_geosolr.repo_name}-prod"
    }
  )
  description = "Full contents of the prod-promote.yml for the geosolr-deposits repo"
}

## For slingshot application repo and ECR repository
# Outputs in dev
output "slingshot_fargate_dev_build_workflow" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/fargate-dev-build.tpl", {
    region = var.aws_region
    role   = module.ecr_slingshot.gha_role
    ecr    = module.ecr_slingshot.repository_name
    }
  )
  description = "Full contents of the dev-build.yml for the slingshot-deposits repo"
}
output "slingshot_fargate_makefile" {
  value = var.environment == "prod" || var.environment == "stage" ? null : templatefile("${path.module}/files/fargate-makefile.tpl", {
    ecr_name = module.ecr_slingshot.repository_name
    ecr_url  = module.ecr_slingshot.repository_url
    }
  )
  description = "Full contents of the Makefile for the slingshot-deposits repo (allows devs to push to Dev account only)"
}

# Outputs in stage
output "slingshot_fargate_stage_build_workflow" {
  value = var.environment == "prod" || var.environment == "dev" ? null : templatefile("${path.module}/files/fargate-stage-build.tpl", {
    region = var.aws_region
    role   = module.ecr_slingshot.gha_role
    ecr    = module.ecr_slingshot.repository_name
    }
  )
  description = "Full contents of the stage-build.yml for the slingshot-deposits repo"
}

# Outputs after promotion to prod
output "slingshot_fargate_prod_promote_workflow" {
  value = var.environment == "stage" || var.environment == "dev" ? null : templatefile("${path.module}/files/fargate-prod-promote.tpl", {
    region     = var.aws_region
    role_stage = "${module.ecr_slingshot.repo_name}-gha-stage"
    role_prod  = "${module.ecr_slingshot.repo_name}-gha-prod"
    ecr_stage  = "${module.ecr_slingshot.repo_name}-stage"
    ecr_prod   = "${module.ecr_slingshot.repo_name}-prod"
    }
  )
  description = "Full contents of the prod-promote.yml for the slingshot-deposits repo"
}

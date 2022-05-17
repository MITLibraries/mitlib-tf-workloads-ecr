# Each .tf file should have a locals block at the top structured as 
# below. This is the location to set the name for the resource(s) 
# being created in that .tf file. This is also the location to flip the 
# "contains-pii" flag from the default of false to true.
#
# The Infra dev will need to update the string for the first row in this
# locals block to an appropriate name for the resources created in this
# file. Depending on the repository, the actual name of the variable might
# also need to be changed. When that is done, ALL occurences of the "_resource"
# must be replaced in the file.
# The text in the variable name after the underscore is necessary to distinguish
# the naming in this file from the naming in other files in this repository.
#
# The locals block below should be copied and pasted into resource-creating .tf
# files. Then, this file should be deleted.
#

locals {
  # This is the base name for resources for this app. A string must be entered
  # betwee the quotes. And, all instances of "_resource" must be replaced with an 
  # identifier that matches the file/resources that are created by this file.
  #
  name_resource     = ""
  fullname_resource = local.project_id == null ? "${var.environment}-${var.name}-${local.name_resource}" : "${var.environment}-${local.project_id}-${var.name}-${local.name_resource}"

  tags_resource = {
    local-resource-name = "${local.name_resource}"
    # The line below can be deleted if there is no PII managed in this 
    # infrastructure since the default value is false. The line should
    # be uncommented if there is PII managed by this infrastructure.
    #
    # contains-pii        = true 
  }
}

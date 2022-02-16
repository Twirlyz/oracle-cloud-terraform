variable "tenant_id" {
  type        = string
  description = "the account tenant ID"
}

variable "compartments" {
  type = map(object({
    root_compartment = string
    policies         = set(string)
  }))

  default     = {}
  description = <<EOF
    map of objects that represent compartments to create. The key name is the compartment name
      root_compartment: ID of the parent compartment
      policies: List of string that represent policies
  EOF
}

variable "enable_delete" {
  type    = bool
  default = true

  description = "wether to allow this compartement to be deleted if there are resources"
}

variable "identity_group_mapping" {
  type = map(object({
    idp_group_name = string
    oci_group_id   = string
    idp_ocid       = string
  }))
  default     = {}
  description = <<EOF
  This is optional. 
  Map of group mapping between idp groups and oci groups
    idp_group_name  : the name of idp group
    oci_group_id    :  ocid group
    idp_ocid        : the OCID of the IDP integration.
  EOF
}

variable "memberships" {
  type        = map(set(string))
  default     = {}
  description = <<EOF
    This variable is optonal.
    Map of groups and users. Map key is the group name, where is the value of the key
    is a list of strings that represent users attached to the group
    The users value is a list of emails, which will be used to create the account
  EOF
}

variable "service_accounts" {
  type        = set(string)
  default     = []
  description = <<EOF
    This variable is optonal.
    Set of service account users. A group with the same name of the service account
    will be created and the service account will be added to it. This is because
    policy can only be applied to group. This way you can attach policy to the service
    account by using its name as group name.
  EOF
}

variable "tenancy_policies" {
  type = object({
    name     = string
    policies = set(string)
  })
  default     = null
  description = <<EOF
    Some policies belong to the tenancy and not to a compartment.
    Pass in a single object that contains the name of policy and list of policies
      name: name for the policy
      policies: list of string of policies to be attached to the tenancy
  EOF
}

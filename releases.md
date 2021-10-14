# V2:
## _**Breaking Changes**_
* `object-storage` module input is updated to include configuration for `lifecycle` managements.
  * Add the following key to every bucket created `lifecycle-rules = {}`. To configure rules, refer to module's readme.
* `network` module input is updated as following:
  * `allowed_ingress_ports` is removed and replaced by the new key `tcp_ingress_ports_from_all` in `default_security_list_rules.public_subnets`.
    * `allowed_ingress_ports` was applied only to **public subnet security list** as TCP ingress. Whatever value you had there add it to `default_security_list_rules.public_subnets.tcp_ingress_ports_from_all`

## **New** 
* Add `vault` module to manage KMS (only key management is enabled)
* (object-storage) Allow to add `lifecycle-rules` to buckets.

## **Enhancement**
* (instances) Allow rename of instance withour recration (breaking change)
  * You need to add `name` attribute to the instance objects you already created.
* (network) Allow display name of subnet to be updated (breaking change)
  * You need to add `name` attribute to the subnet objects you already created.
# V2:
## _**Breaking Changes**_
* `public_ip` module input name is changed from `ips` to `untracked_ips`.
  * This is to distinguish public IPs that will be managed by Terraform. 
  * output of module changed. Previously named `ips` renamed to `untracked_ips`
* `object-storage` module input is updated to include configuration for `lifecycle` managements.
  * Add the following key to every bucket created `lifecycle-rules = {}`. To configure rules, refer to module's readme.
* `network` module input is updated as following:
  * `allowed_ingress_ports` is removed and replaced by the new key `tcp_ingress_ports_from_all` in `default_security_list_rules.public_subnets`.
    * `allowed_ingress_ports` was applied only to **public subnet security list** as TCP ingress. Whatever value you had there add it to `default_security_list_rules.public_subnets.tcp_ingress_ports_from_all`
  * `tcp_ingress_ports_from_vcn` and `udp_ingress_ports_from_vcn` are added to `default_security_list_rules.private_subnets`
  * NAT Gateway and Internet Gateway resource name has changed. Run the following command manually to update the state names
  
  Internet Gateway Resource 
  ```
  terraform state mv module.NETWORK_MODULE_NAME.oci_core_internet_gateway mv module.module.NETWORK_MODULE_NAME.oci_core_internet_gateway\[0\]
  ```
  Nat Gateway Resource 
  ```
  terraform state mv module.NETWORK_MODULE_NAME.oci_core_nat_gateway mv module.module.NETWORK_MODULE_NAME.oci_core_nat_gateway\[0\]
  ```
  Public Route Table Resource 
  ```
  terraform state mv module.NETWORK_MODULE_NAME.oci_core_default_route_table.public_route_table module.NETWORK_MODULE_NAME.oci_core_default_route_table.public_route_table\[\"igw=true\"\]
  ```
  Private Route Table Resource
  ```
  terraform state mv module.NETWORK_MODULE_NAME.oci_core_route_table.private_route_table module.NETWORK_MODULE_NAME.oci_core_route_table.private_route_table\[\"natgw=true:svcgw=false\"\]
  ```
* `instances` modules output is updated:
  * `public_ip` and `private_ip`, and `private_ip` is renamed to `ip_address`:
  ```
  "primary_vnic" = {
      "primary_ip" = {
        "id" = "ocid1.privateip.oc1.xxxxxxxxxxxxxxxx"
        "ip_address" = "xxx.xxx.xxx.xxx"
        "public_ip" = "xxx.xxx.xxx.xxx"
        "subnet_id" = "ocid1.subnet.oc1.xxxxxxxxxxxxxxx"
        "vnic_id" = "ocid1.vnic.oc1.xxxxxxxxxxxxxxx"
      }
      "secondary_ips" = {
        ...
        ...
      }
  }
  ```
* `instances` modules input is updated as following:
  * `config` object has new attribute `primary_vnic`.
    * Add the following when upgrading to fix it.
    ```
    ...
    ...
    config = { 
      primary_vnic = {  <------ this line start
        primary_ip = "", 
        secondary_ips = {}
      } <------ this line end
    }
    ...
    ...
    ```
  * `secondary_vnics` is new attribute to instance object.
    * Add the following to instance object.
    ```
    {
      ...
      ...
      config = {
      ...
      ...
      }
      secondary_vnics = {} <------ this line
      ...
      ...
    }
    ```
## **New** 
* Add `vault` module to manage KMS (only key management is enabled)
* (`object-storage`) Allow to add `lifecycle-rules` to buckets.
* (`instance`) Ability to add multiple secondary IPs to primary VNIC
* (`instance`) Ability to add multiple secondary VNICs and multiple private IPs
* (`public-ip`) Ability to attach public ip to a given private IP
* (`network`) Ability to 
  * configure `NAT Gateway` (enable/disable, block traffic, assign reserved public IP)
  * configure `Internet Gateway` (enable/disable gateway)
  * Create `Service Gateway`.

## **Enhancement**
* (instances) Allow rename of instance withour recration (breaking change)
  * You need to add `name` attribute to the instance objects you already created.
* (network) Allow display name of subnet to be updated (breaking change)
  * You need to add `name` attribute to the subnet objects you already created.
# variables.tf
variable "access_key" {
     default = "AKIA5HZJHPC2V4SOCW4Z"
}
variable "secret_key" {
     default = "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"
}
variable "region" {
     default = "eu-west-1"
}
variable "availabilityZone1" {
     default = "eu-west-1a"
}
variable "availabilityZone2" {
     default = "eu-west-1b"
}
variable "instanceTenancy" {
    default = "default"
}
variable "dnsSupport" {
    default = true
}
variable "dnsHostNames" {
    default = true
}
variable "vpcCIDRblockMikaeil" {
    default = "10.102.0.0/16"
}
variable "vpcCIDRblockMikaeilDB" {
    default = "10.200.0.0/16"
}
variable "subnetCIDRblockMikaeilNAT" {
    default = "10.102.255.0/24"
}
variable "subnetCIDRblockMikaeilNATDB" {
    default = "10.200.255.0/24"
}
variable "subnetCIDRblockMikaeilBackendAZ1" {
    default = "10.102.3.0/24"
}
variable "subnetCIDRblockMikaeilBackendAZ2" {
    default = "10.102.4.0/24"
}
variable "subnetCIDRblockMikaeilFrontendAZ1" {
    default = "10.102.1.0/24"
}
variable "subnetCIDRblockMikaeilFrontendAZ2" {
    default = "10.102.2.0/24"
}
variable "subnetCIDRblockMikaeilDB" {
    default = "10.200.3.0/24"
}
variable "destinationCIDRblock" {
    default = "0.0.0.0/0"
}
variable "ingressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "egressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "mapPublicIP" {
    default = true
}
variable "unmapPublicIP" {
    default = false
}
# end of variables.tf
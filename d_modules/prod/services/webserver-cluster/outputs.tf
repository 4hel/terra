output "elb_dns_name" {
  value = "${module.webserver-cluster.elb_dns_name}"
}

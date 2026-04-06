output "alb_dns_name" {
  value = aws_lb.test.dns_name

}

output "alb_zone_id" {
  value = aws_lb.test.zone_id

}




# once the load balancer is created , it will produce both the dns name and the zone ID 

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "target_group_arn" {
  value = aws_lb_target_group.test.arn
}
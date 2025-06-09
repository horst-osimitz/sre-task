output "ec2_instance_webserver" {
  description = "Public DNS of the Webserver EC2 instance"
  value       = module.ec2_instance_webserver.public_dns
}

output "ec2_instance_id_webserver" {
  description = "Webserver EC2 Instance ID"
  value       = module.ec2_instance_webserver.id
}

output "ec2_instance_state_webserver" {
  description = "Webserver EC2 Instance state"
  value       = module.ec2_instance_webserver.instance_state
}

output "ec2_key_aws_ssm_webserver" {
  description = "Arn of Webserver AWS Key Pair private key in AWS Secretsmanager"
  value       = aws_secretsmanager_secret.private_key_webserver.arn
}

output "aws_eip_webserver" {
  description = "Webserver EC2 Instance public IP"
  value       = aws_eip.ec2_instance_webserver.public_ip
}

output "ec2_instance_webserver_private_ip" {
  description = "Webserver EC2 Instance private IP"
  value       = module.ec2_instance_webserver.private_ip
}

# Ansible
# output "ec2_instance_ansible" {
#   description = "Public DNS of the Ansible EC2 instance"
#   value       = module.ec2_instance_ansible.public_dns
# }
#
# output "ec2_instance_id_ansible" {
#   description = "Ansible EC2 Instance ID"
#   value       = module.ec2_instance_ansible.id
# }
#
# output "ec2_instance_state_ansible" {
#   description = "Ansible EC2 Instance state"
#   value       = module.ec2_instance_ansible.instance_state
# }
#
# output "ec2_key_aws_ssm_ansible" {
#   description = "Arn of Ansible AWS Key Pair private key in AWS Secretsmanager"
#   value       = aws_secretsmanager_secret.private_key_ansible.arn
# }
#
# output "aws_eip_ansible" {
#   description = "Ansible EC2 Instance public IP"
#   value       = aws_eip.ec2_instance_ansible.public_ip
# }
#
# output "ec2_instance_ansible_private_ip" {
#   description = "Ansible EC2 Instance private IP"
#   value       = module.ec2_instance_ansible.private_ip
# }

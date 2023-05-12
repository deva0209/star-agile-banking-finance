provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIAUEQBJJJTRK4MZGO7"
  secret_key = "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"
}
resource "aws_instance" "test-server" {
  ami           = "ami-0d683450f458cdbaa" 
  instance_type = "t2.micro"
  key_name = "gnan"
  vpc_security_group_ids= ["sg-09e2c8be5cc7b0db2"]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("gnan.pem")
    host     = self.public_ip
  }
provisioner "remote-exec" {
    inline = [ "echo 'wait to start instance' "]
  }
  tags = {
    Name = "test-server"
  }
  provisioner "local-exec" {
        command = " echo ${aws_instance.test-server.public_ip} > inventory "
		}
  provisioner "local-exec" {
  command = "ansible-playbook /var/lib/jenkins/workspace/finance/serverfiles/bankingplaybook.yml"
}
}

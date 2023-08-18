resource "aws_security_group" "ssh_sg" {
  name   = "sshAccess"
  vpc_id = data.aws_vpc.default.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "ssh_rule" {
  type = "ingress"
  protocol = "tcp"
  from_port = 22
  to_port = 22
  cidr_blocks = var.ssh_ips
  security_group_id = "${aws_security_group.ssh_sg.id}"
}
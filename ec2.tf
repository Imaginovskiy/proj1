resource "aws_iam_role" "ec2_role" {
  name = "EC2InstanceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action   = "sts:AssumeRole",
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "s3_access_attachment" {
  policy_arn = aws_iam_policy.s3_access_policy.arn
  role       = aws_iam_role.ec2_role.name
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
    name = "ec2_test_profile"
    role = "${aws_iam_role.ec2_role.name}"
}

resource "aws_instance" "test_ec2_instance" {
  ami           = "ami-09e8e9f9b1b4067d9"
  instance_type = "t4g.micro"
  subnet_id = "subnet-00a5a42cb26be162f"
  vpc_security_group_ids = [aws_security_group.ssh_sg.id]
  key_name = "MyKeyPair"
  
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  tags = {
    Name = "ExampleInstance"
  }
}
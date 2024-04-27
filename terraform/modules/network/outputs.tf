output "public_subnets" {
  value  = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
}

output "private_subnets" {
  value  = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
}

output "vpc" {
  value  = aws_vpc.this.id
}
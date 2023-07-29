resource "aws_vpc" "main" {
  cidr_block = "192.168.0.0/16"

  tags = {
    Name = "project-vpc"
  }
}

resource "aws_subnet" "public-a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "192.168.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "web-subnet-1"
  }
}

resource "aws_subnet" "private-a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.11.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "app-subnet-1"
  }
}

resource "aws_subnet" "data-a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.21.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "data-subnet-1"
  }
}



resource "aws_subnet" "public-b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "192.168.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "web-subnet-2"
  }
}


resource "aws_subnet" "private-b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.12.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "app-subnet-2"
  }
}

resource "aws_subnet" "data-b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.22.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "data-subnet-2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "project-vpc-igw"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public-b.id

  tags = {
    Name = "project-vpc-nat_gw"
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_route_table" "nat_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "nat-route-table"
  }
}

resource "aws_route_table" "internet_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "internet-route-table"
  }
}

# ASSOCIATE ROUTE TABLE -- WEB LAYER 1
resource "aws_route_table_association" "internet_route_table_association_public_a" {
  subnet_id      = aws_subnet.public-a.id
  route_table_id = aws_route_table.internet_route_table.id
}

# ASSOCIATE ROUTE TABLE -- APP LAYER 1
resource "aws_route_table_association" "nat_route_table_association_private_a" {
  subnet_id      = aws_subnet.private-a.id
  route_table_id = aws_route_table.nat_route_table.id
}

# ASSOCIATE ROUTE TABLE -- DATA LAYER 1
resource "aws_route_table_association" "nat_route_table_association_data_a" {
  subnet_id      = aws_subnet.data-a.id
  route_table_id = aws_route_table.nat_route_table.id
}

# ASSOCIATE ROUTE TABLE -- WEB LAYER 2
resource "aws_route_table_association" "internet_route_table_association_public_b" {
  subnet_id      = aws_subnet.public-b.id
  route_table_id = aws_route_table.internet_route_table.id
}

# ASSOCIATE ROUTE TABLE -- APP LAYER 2
resource "aws_route_table_association" "nat_route_table_association_private_b" {
  subnet_id      = aws_subnet.private-b.id
  route_table_id = aws_route_table.nat_route_table.id
}

# ASSOCIATE ROUTE TABLE -- DATA LAYER 2
resource "aws_route_table_association" "nat_route_table_association_data_b" {
  subnet_id      = aws_subnet.data-b.id
  route_table_id = aws_route_table.nat_route_table.id
}
# vpc.tf 
# Create VPC/Subnet/Security Group/Network ACL
provider "aws" {
  version = "~> 3.0"
  access_key = var.access_key 
  secret_key = var.secret_key 
  region     = var.region
}
# create the VPC
resource "aws_vpc" "Mikaeil_VPC" {
  cidr_block           = var.vpcCIDRblockMikaeil
  instance_tenancy     = var.instanceTenancy 
  enable_dns_support   = var.dnsSupport 
  enable_dns_hostnames = var.dnsHostNames
tags = {
    Name = "Mikaeil VPC"
}
} # end resource
# create the Subnet
resource "aws_subnet" "Mikaeil_NAT_Subnet" {
  vpc_id                  = aws_vpc.Mikaeil_VPC.id
  cidr_block              = var.subnetCIDRblockMikaeilNAT
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.availabilityZone1
tags = {
   Name = "Mikaeil NAT Subnet"
}
} # end resource
# create the Subnet
resource "aws_subnet" "Mikaeil_Backend_Priv_Subnet_1" {
  vpc_id                  = aws_vpc.Mikaeil_VPC.id
  cidr_block              = var.subnetCIDRblockMikaeilBackendAZ1
  map_public_ip_on_launch = var.unmapPublicIP 
  availability_zone       = var.availabilityZone1
tags = {
   Name = "Mikaeil Backend(Priv) Subnet №1"
}
} # end resource
# create the Subnet
resource "aws_subnet" "Mikaeil_Backend_Priv_Subnet_2" {
  vpc_id                  = aws_vpc.Mikaeil_VPC.id
  cidr_block              = var.subnetCIDRblockMikaeilBackendAZ2
  map_public_ip_on_launch = var.unmapPublicIP 
  availability_zone       = var.availabilityZone2
tags = {
   Name = "Mikaeil Backend(Priv) Subnet №2"
}
} # end resource
# create the Subnet
resource "aws_subnet" "Mikaeil_Frontend_Priv_Subnet_1" {
  vpc_id                  = aws_vpc.Mikaeil_VPC.id
  cidr_block              = var.subnetCIDRblockMikaeilFrontendAZ1
  map_public_ip_on_launch = var.unmapPublicIP 
  availability_zone       = var.availabilityZone1
tags = {
   Name = "Mikaeil Frontend(Priv) Subnet №1"
}
} # end resource
# create the Subnet
resource "aws_subnet" "Mikaeil_Frontend_Priv_Subnet_2" {
  vpc_id                  = aws_vpc.Mikaeil_VPC.id
  cidr_block              = var.subnetCIDRblockMikaeilFrontendAZ2
  map_public_ip_on_launch = var.unmapPublicIP 
  availability_zone       = var.availabilityZone2
tags = {
   Name = "Mikaeil Frontend(Priv) Subnet №2"
}
} # end resource
# Create the Security Group
resource "aws_security_group" "Mikaeil_NAT_VPC_Security_Group" {
  vpc_id       = aws_vpc.Mikaeil_VPC.id
  name         = "Mikaeil NAT SG"
  description  = "Mikaeil NAT SG"
  
  # # allow ingress of port 22
  # ingress { 
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   #security_groups = aws_security_group.Mikaeil_Priv_VPC_Security_Group.id
  # }

   ingress { 
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }  
  
  ingress { 
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }  
  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
   Name = "Mikaeil NAT SG"
   Description = "Mikaeil NAT SG"
}
}
resource "aws_security_group" "Mikaeil_Priv_VPC_Security_Group" {
  vpc_id       = aws_vpc.Mikaeil_VPC.id
  name         = "Mikaeil Priv SG"
  description  = "Mikaeil Priv SG"
  
  # allow ingress of port 22
  # ingress { 
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   #security_groups = aws_security_group.Mikaeil_NAT_VPC_Security_Group.id
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
   Name = "Mikaeil Priv SG"
   Description = "Mikaeil Priv SG"
}
} # end resource
resource "aws_security_group_rule" "Mikaeil_NAT_SG_Allow_traffic" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = aws_security_group.Mikaeil_Priv_VPC_Security_Group.id
  security_group_id = aws_security_group.Mikaeil_NAT_VPC_Security_Group.id
}
 # end resource

resource "aws_security_group_rule" "Mikaeil_Main_Priv_SG_Allow_traffic" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = aws_security_group.Mikaeil_NAT_VPC_Security_Group.id
  security_group_id = aws_security_group.Mikaeil_Priv_VPC_Security_Group.id
} # end resource
# create VPC Network access control list
resource "aws_network_acl" "My_VPC_Security_ACL" {
  vpc_id = aws_vpc.Mikaeil_VPC.id
  subnet_ids = [ aws_subnet.Mikaeil_NAT_Subnet.id, aws_subnet.Mikaeil_Backend_Priv_Subnet_1.id, aws_subnet.Mikaeil_Backend_Priv_Subnet_2.id, aws_subnet.Mikaeil_Frontend_Priv_Subnet_1.id, aws_subnet.Mikaeil_Frontend_Priv_Subnet_1.id ]
# allow ingress port 22
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock 
    from_port  = 0
    to_port    = 0
  }
  
  # allow egress port 22 
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 0 
    to_port    = 0
  }
tags = {
    Name = "My VPC ACL"
}
} # end resource
# Create the Internet Gateway
resource "aws_internet_gateway" "Mikaeil_VPC_GW" {
 vpc_id = aws_vpc.Mikaeil_VPC.id
 tags = {
        Name = "Mikaeil VPC Internet Gateway"
}
} # end resource
resource "aws_network_interface" "Main_NAT_NetI" {
  subnet_id   = aws_subnet.Mikaeil_NAT_Subnet.id
  private_ips = ["10.102.255.100"]
  security_groups = [aws_security_group.Mikaeil_NAT_VPC_Security_Group.id]
  source_dest_check = false

  tags = {
    Name = "primary_network_interface"
  }
}
resource "aws_instance" "Main_NAT" {
  ami           = "ami-0f9f532f86eee2b85"
  instance_type = "t3.micro"
  key_name = aws_key_pair.generated_key.key_name
  #subnet_id = aws_subnet.Mikaeil_NAT_Subnet.id
  #vpc_security_group_ids = [aws_security_group.Mikaeil_NAT_VPC_Security_Group.id]
  #associate_public_ip_address = true
  availability_zone = var.availabilityZone1
  network_interface {
    network_interface_id = aws_network_interface.Main_NAT_NetI.id
    device_index         = 0
  } 
  tags = {
    Name ="Main NAT"
  }
}
resource "aws_eip" "Main_EIP" {
    vpc = true
    instance = aws_instance.Main_NAT.id
}
resource "tls_private_key" "priv_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "MikaeilKeyPair"
  public_key = tls_private_key.priv_key.public_key_openssh
}
resource "local_file" "MikaeilKeyPair_pem" { 
  filename = "MikaeilKeyPair.pem"
  content = tls_private_key.priv_key.private_key_pem
}
# resource "aws_key_pair" "keypair" {
#   key_name = "MikaeilKeyPair"
#   public_key = file("MikaeilKeyPair.pem")
# }
resource "aws_network_interface" "DB_NAT_NetI" {
  subnet_id   = aws_subnet.Mikaeil_NAT_DB_Subnet.id
  private_ips = ["10.200.255.100"]
  security_groups = [aws_security_group.Mikaeil_NAT_DB_VPC_Security_Group.id]
  source_dest_check = false

  tags = {
    Name = "primary_network_interface"
  }
}
resource "aws_instance" "DB_NAT" {
  ami           = "ami-0f9f532f86eee2b85"
  instance_type = "t3.micro"
  key_name = aws_key_pair.generated_key.key_name
  #subnet_id = aws_subnet.Mikaeil_NAT_DB_Subnet.id
  #vpc_security_group_ids = [aws_security_group.Mikaeil_NAT_DB_VPC_Security_Group.id]
  #associate_public_ip_address = true
  availability_zone = var.availabilityZone1
  network_interface {
    network_interface_id = aws_network_interface.DB_NAT_NetI.id
    device_index         = 0
  } 
  tags = {
    Name ="DB NAT"
  }
}
resource "aws_eip" "DB_EIP" {
    vpc = true
    instance = aws_instance.DB_NAT.id
}
resource "aws_network_interface" "Main_Frontend_Priv_NetI" {
  subnet_id   = aws_subnet.Mikaeil_Frontend_Priv_Subnet_1.id
  private_ips = ["10.102.1.20"]
  security_groups = [aws_security_group.Mikaeil_Priv_VPC_Security_Group.id]

  tags = {
    Name = "primary_network_interface"
  }
}
resource "aws_instance" "Main_Frontend" {
  ami           = "ami-0dc8d444ee2a42d8a"
  instance_type = "t3.micro"
  key_name = aws_key_pair.generated_key.key_name
  #subnet_id = aws_subnet.Mikaeil_Frontend_Priv_Subnet_1.id
  #vpc_security_group_ids = [aws_security_group.Mikaeil_Priv_VPC_Security_Group.id]
  #associate_public_ip_address = false
  availability_zone = var.availabilityZone1
  network_interface {
    network_interface_id = aws_network_interface.Main_Frontend_Priv_NetI.id
    device_index         = 0
  } 
  tags = {
    Name ="Frontend"
  }
}
resource "aws_network_interface" "Main_Priv_Backend_NetI" {
  subnet_id   = aws_subnet.Mikaeil_Backend_Priv_Subnet_1.id
  private_ips = ["10.102.3.20"]
  security_groups = [aws_security_group.Mikaeil_Priv_VPC_Security_Group.id]

  tags = {
    Name = "primary_network_interface"
  }
}
resource "aws_instance" "Main_Backend" {
  ami           = "ami-0dc8d444ee2a42d8a"
  instance_type = "t3.micro"
  key_name = aws_key_pair.generated_key.key_name
  #subnet_id = aws_subnet.Mikaeil_Backend_Priv_Subnet_1.id
  #vpc_security_group_ids = [aws_security_group.Mikaeil_Priv_VPC_Security_Group.id]
  #associate_public_ip_address = false
  availability_zone = var.availabilityZone1
  network_interface {
    network_interface_id = aws_network_interface.Main_Priv_Backend_NetI.id
    device_index         = 0
  } 
  tags = {
    Name ="Backend"
  }
}
# create the VPC
resource "aws_vpc" "Mikaeil_DB_VPC" {
  cidr_block           = var.vpcCIDRblockMikaeilDB
  instance_tenancy     = var.instanceTenancy 
  enable_dns_support   = var.dnsSupport 
  enable_dns_hostnames = var.dnsHostNames
tags = {
    Name = "Mikaeil DB VPC"
}
} # end resource
# create the Subnet
resource "aws_subnet" "Mikaeil_NAT_DB_Subnet" {
  vpc_id                  = aws_vpc.Mikaeil_DB_VPC.id
  cidr_block              = var.subnetCIDRblockMikaeilNATDB
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.availabilityZone1
tags = {
   Name = "Mikaeil NAT DB Subnet"
}
} # end resource
# create the Subnet
resource "aws_subnet" "Mikaeil_DB_Subnet" {
  vpc_id                  = aws_vpc.Mikaeil_DB_VPC.id
  cidr_block              = var.subnetCIDRblockMikaeilDB
  map_public_ip_on_launch = var.unmapPublicIP 
  availability_zone       = var.availabilityZone1
tags = {
   Name = "Mikaeil DB Subnet"
}
} # end resource
# Create the Security Group
resource "aws_security_group" "Mikaeil_NAT_DB_VPC_Security_Group" {
  vpc_id       = aws_vpc.Mikaeil_DB_VPC.id
  name         = "Mikaeil NAT DB SG"
  description  = "Mikaeil NAT DB SG "
  
  # allow ingress of port 22
  # ingress { 
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   #security_groups = aws_security_group.Mikaeil_Priv_DB_VPC_Security_Group.id
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
   Name = "Mikaeil DB NAT SG"
   Description = "Mikaeil DB NAT SG"
}
}
resource "aws_security_group_rule" "Mikaeil_NAT_DB_SG_Allow_traffic" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = aws_security_group.Mikaeil_Priv_DB_VPC_Security_Group.id
  security_group_id = aws_security_group.Mikaeil_NAT_DB_VPC_Security_Group.id
} # end resource
# Create the Security Group
resource "aws_security_group" "Mikaeil_Priv_DB_VPC_Security_Group" {
  vpc_id       = aws_vpc.Mikaeil_VPC.id
  name         = "Mikaeil DB Priv SG"
  description  = "Mikaeil DB Priv SG"
  
  # allow ingress of port 22
  # ingress { 
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   #security_groups = aws_security_group.Mikaeil_NAT_DB_VPC_Security_Group.id
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
   Name = "Mikaeil DB Priv SG"
   Description = "Mikaeil DB Priv SG"
}
} # end resource
resource "aws_security_group_rule" "Mikaeil_Priv_DB_SG_Allow_traffic" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = aws_security_group.Mikaeil_NAT_DB_VPC_Security_Group.id
  security_group_id = aws_security_group.Mikaeil_Priv_DB_VPC_Security_Group.id
} # end resource
# create VPC Network access control list
resource "aws_network_acl" "Mikaeil_DB_VPC_Security_ACL" {
  vpc_id = aws_vpc.Mikaeil_DB_VPC.id
  subnet_ids = [ aws_subnet.Mikaeil_NAT_DB_Subnet.id , aws_subnet.Mikaeil_DB_Subnet.id ]
# allow ingress port all traffic
    ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock 
    from_port  = 0
    to_port    = 0
  }
  
  # allow egress port all traffic 
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 0 
    to_port    = 0
  }
tags = {
    Name = "Mikaeil DB VPC ACL"
}
} # end resource
# Create the Internet Gateway
resource "aws_internet_gateway" "Mikaeil_DB_VPC_GW" {
 vpc_id = aws_vpc.Mikaeil_DB_VPC.id
 tags = {
        Name = "Mikaeil DB VPC Internet Gateway"
}
} # end resource
resource "aws_vpc_peering_connection" "MainToDB" {
  #peer_owner_id = var.peer_owner_id
  peer_vpc_id   = aws_vpc.Mikaeil_DB_VPC.id
  vpc_id        = aws_vpc.Mikaeil_VPC.id
  auto_accept   = true

  tags = {
    Name = "VPC Peering between Mikaeil VPC and Mikaeil DB VPC"
  }
}
 # Create the Route Table
 resource "aws_route_table" "Mikaeil_NAT_RT" {
  vpc_id = aws_vpc.Mikaeil_VPC.id
  tags = {
         Name = "Mikaeil NAT RT"
}
} # end resource
 # Create the Internet Access
 resource "aws_route" "Mikaeil_NAT_internet_access" {
   route_table_id         = aws_route_table.Mikaeil_NAT_RT.id
   destination_cidr_block = var.destinationCIDRblock
   gateway_id             = aws_internet_gateway.Mikaeil_VPC_GW.id
} # end resource
 # Associate the Route Table with the Subnet
 resource "aws_route_table_association" "Mikaeil_Main_Nat_association" {
   subnet_id      = aws_subnet.Mikaeil_NAT_Subnet.id
   route_table_id = aws_route_table.Mikaeil_NAT_RT.id
} # end resource
 # Create the Route Table
 resource "aws_route_table" "Mikaeil_RT" {
  vpc_id = aws_vpc.Mikaeil_VPC.id
  tags = {
         Name = "Mikaeil RT"
}
} # end resource
# Create Peering connection
 resource "aws_route" "Mikaeil_Main_Priv_peering_connection" {
   route_table_id         = aws_route_table.Mikaeil_RT.id
   destination_cidr_block = "10.200.3.0/24"
   vpc_peering_connection_id = aws_vpc_peering_connection.MainToDB.id
} # end resource
 resource "aws_route" "Mikaeil_Main_Priv_internet_access" {
   route_table_id         = aws_route_table.Mikaeil_RT.id
   destination_cidr_block = var.destinationCIDRblock
   network_interface_id = aws_network_interface.Main_NAT_NetI.id
} # end resource
 resource "aws_route_table_association" "Mikaeil_Frontend_association" {
   subnet_id      = aws_subnet.Mikaeil_Frontend_Priv_Subnet_1.id
   route_table_id = aws_route_table.Mikaeil_RT.id
   } # end resource
 resource "aws_route_table_association" "Mikaeil_Backend_association" {
   subnet_id      = aws_subnet.Mikaeil_Backend_Priv_Subnet_1.id
   route_table_id = aws_route_table.Mikaeil_RT.id
   } # end resource
# Create the Route Table
 resource "aws_route_table" "Mikaeil_DB_NAT_RT" {
  vpc_id = aws_vpc.Mikaeil_DB_VPC.id
  tags = {
         Name = "Mikaeil DB NAT RT"
}
} # end resource
 # Create the Internet Access
 resource "aws_route" "Mikaeil_DB_NAT_internet_access" {
   route_table_id         = aws_route_table.Mikaeil_DB_NAT_RT.id
   destination_cidr_block = var.destinationCIDRblock
   gateway_id             = aws_internet_gateway.Mikaeil_DB_VPC_GW.id
} # end resource
 # Associate the Route Table with the Subnet
 resource "aws_route_table_association" "Mikaeil_DB_Nat_association" {
   subnet_id      = aws_subnet.Mikaeil_NAT_Subnet.id
   route_table_id = aws_route_table.Mikaeil_NAT_RT.id
} # end resource
# Create the Route Table
 resource "aws_route_table" "Mikaeil_DB_RT" {
  vpc_id = aws_vpc.Mikaeil_DB_VPC.id
  tags = {
         Name = "Mikaeil DB RT"
}
} # end resource
resource "aws_route" "Mikaeil_DB_Priv_peering_connection" {
   route_table_id         = aws_route_table.Mikaeil_DB_RT.id
   destination_cidr_block = "10.102.1.0/24"
   vpc_peering_connection_id = aws_vpc_peering_connection.MainToDB.id
} # end resource
 # Create the Internet Access
 resource "aws_route" "Mikaeil_DB_Priv_internet_access" {
   route_table_id         = aws_route_table.Mikaeil_DB_RT.id
   destination_cidr_block = var.destinationCIDRblock
   network_interface_id   = aws_network_interface.DB_NAT_NetI.id
} # end resource
 # Associate the Route Table with the Subnet
 resource "aws_route_table_association" "Mikaeil_DB_Priv_association" {
   subnet_id      = aws_subnet.Mikaeil_DB_Subnet.id
   route_table_id = aws_route_table.Mikaeil_DB_RT.id
} # end resource
# # end vpc.tf
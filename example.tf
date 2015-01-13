provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

resource "aws_security_group" "default" {
    name = "terraform_example"
    description = "Used in the terraform"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_eip" "ip" {
    instance = "${aws_instance.example.id}"
}

resource "aws_instance" "example" {
    ami = "${lookup(var.amis, var.region)}"
    instance_type = "t1.micro"

    connection {
        user = "ubuntu"
        key_file = "${var.key_path}"
    }

    key_name = "${var.key_name}"
    security_groups = ["${aws_security_group.default.name}"]
}

output "ip" {
    value = "${aws_eip.ip.public_ip}"
}

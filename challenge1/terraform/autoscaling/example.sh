#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
echo "This is my firstwebapp " > /var/www/html/index.html
sudo systemctl start httpd
sudo systemct enable httpd

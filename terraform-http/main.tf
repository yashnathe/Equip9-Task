provider "aws" {
  region = "ap-south-1"  # Modify this with the appropriate region
}

# Create a Security Group to allow HTTP (80), HTTPS (443), and Flask (5000) traffic
resource "aws_security_group" "http_sg" {
  name        = "http-sg1"
  description = "Allow HTTP, HTTPS, and Flask traffic"
  
  # Allow HTTP traffic (port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS traffic (port 443)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow Flask app traffic (port 5000)
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an EC2 instance to host the HTTP service
resource "aws_instance" "http_service" {
  ami           = "ami-053b12d3152c0cc71"  # Update with a valid AMI for your region
  instance_type = "t2.micro"               # Choose an appropriate instance type
  key_name      = "techai404keypair"
  security_groups = [aws_security_group.http_sg.name]

  # Add user data to install and run your HTTP service
  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y python3-pip

              # Install Flask and Boto3
              pip3 install flask boto3
              
              # Create a Python app.py script on the EC2 instance
              cat <<'EOT' > /home/ubuntu/app.py
              import boto3
              from flask import Flask, jsonify
              import os

              app = Flask(__name__)

              # Initialize the S3 client
              s3 = boto3.client('s3')
              BUCKET_NAME = 'myequip9-task'  # Modify with your actual S3 bucket name

              def list_s3_content(prefix=''):
                  """List the contents of the S3 bucket for a given prefix."""
                  try:
                      response = s3.list_objects_v2(Bucket=BUCKET_NAME, Prefix=prefix, Delimiter='/')
                      dirs = []
                      files = []
                      if 'CommonPrefixes' in response:
                          dirs = [prefix['Prefix'].split('/')[-2] for prefix in response['CommonPrefixes']]
                      if 'Contents' in response:
                          files = [obj['Key'].split('/')[-1] for obj in response['Contents']]
                      return dirs + files
                  except Exception as e:
                      return str(e)

              @app.route('/list-bucket-content', methods=['GET'])
              @app.route('/list-bucket-content/<path:path>', methods=['GET'])
              def list_bucket_content(path=None):
                  if path:
                      content = list_s3_content(prefix=path + '/')
                  else:
                      content = list_s3_content()

                  return jsonify({'content': content})

              if __name__ == '__main__':
                  app.run(debug=True, host='0.0.0.0', port=5000)
              EOT

              # Create a systemd service to run the Flask app on boot
              cat <<'EOT' > /etc/systemd/system/flask_app.service
              [Unit]
              Description=Flask Application

              [Service]
              ExecStart=/usr/bin/python3 /home/ubuntu/app.py
              WorkingDirectory=/home/ubuntu
              Restart=always
              User=ubuntu

              [Install]
              WantedBy=multi-user.target
              EOT

              # Reload systemd, enable and start the Flask service
              systemctl daemon-reload
              systemctl enable flask_app.service
              systemctl start flask_app.service
              EOF

  tags = {
    Name = "HTTP-Service-EC2"
  }
}

# Output the public IP of the EC2 instance
output "http_service_ip" {
  value = aws_instance.http_service.public_ip
}

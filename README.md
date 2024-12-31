# Equip9 Assessment

## Name: Yash Nathe  
## Email: yashnathe2001@gmail.com
## Date: 31-12-2024

---

## Task 1: HTTP Service with AWS S3 Integration

# S3 Bucket Content Listing HTTP Service

This repository contains an HTTP service that interacts with an AWS S3 bucket to list its contents, either at the top-level or within a specific path. The service is built using **Flask** and interacts with **AWS SDK (Boto3)** to retrieve data from the S3 bucket. The service is deployed using **Terraform** to provision the necessary AWS infrastructure, such as EC2 and security groups.

## Features

1. **List S3 Bucket Contents:**
   - Retrieve the contents of an S3 bucket or a specified directory.
   - Supports paths (directories) within the bucket.
   - Returns the content in JSON format.

2. **API Endpoints:**
   - **GET `/list-bucket-content`**  
     Returns the top-level content of the S3 bucket.  
     **Example Response:**
     ```json
     {
       "content": ["dir1", "dir2", "file1", "file2"]
     }
     ```

      - **GET `/list-bucket-content/<path>`**  
     Returns the contents of the specified directory.  
     **Example Response for `/list-bucket-content/dir2`:**
     ```json
     {
       "content": ["file1", "file2"]
     }
     ```

   - If the specified directory is empty or non-existent, an empty array is returned.

3. **Error Handling:**
   - Gracefully handles invalid or non-existing paths by returning an empty content list or an error message.

## Prerequisites

- **AWS Account** with appropriate permissions to provision resources (EC2, S3, IAM).
- **Terraform** installed on your machine for deployment.
- **Python 3** installed (for local testing of the Flask app).

## Getting Started

Follow the steps below to set up and run the HTTP service locally and deploy it to AWS.

### Local Setup (For Testing)

1. Clone this repository:

    ```bash
    git clone https://github.com/yourusername/s3-bucket-content-service.git
    cd s3-bucket-content-service
    ```

2. Install the required Python packages:

    ```bash
    pip install flask boto3
    ```

3. Set up your AWS credentials. Make sure the AWS CLI is configured with the correct IAM credentials:

    ```bash
    aws configure
    ```

4. Run the Flask app locally:

    ```bash
    python app.py
    ```

5. The service should be running at `http://localhost:5000`. You can now test the endpoints:

   - **Top-level content**:  
     `GET http://localhost:5000/list-bucket-content`
     
   - **Directory-specific content**:  
     `GET http://localhost:5000/list-bucket-content/dir1`

### AWS Deployment Using Terraform

1. Ensure Terraform is installed on your machine. If not, follow the [installation guide](https://learn.hashicorp.com/tutorials/terraform/install-cli).

2. Modify the following in the Terraform code:
   - Set your own **S3 bucket name** in `BUCKET_NAME`.
   - Modify the **AMI ID** in `aws_instance` for your region (check the [AWS AMI documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) for the appropriate one).

3. Initialize Terraform:

    ```bash
    terraform init
    ```

4. Apply the Terraform configuration:

    ```bash
    terraform apply
    ```

   This will provision an EC2 instance, configure the security group, and deploy the Flask app.

5. Once the deployment is complete, Terraform will output the public IP address of the EC2 instance. Access the HTTP service by navigating to:

    ```bash
    http://<public-ip>:5000/list-bucket-content
    ```

# Video Demo and Screenshots

To provide a comprehensive demo of your solution, please upload a short video demo and screenshots showcasing:

- The **S3 bucket structure** (before and after uploading files).
- **API responses** from `GET /list-bucket-content` and `GET /list-bucket-content/<path>`.

These files will help others understand how your service works and demonstrate its capabilities.

## Steps to Upload:

### 1. Video Demo:
Create a video showing:
- How the service works with the S3 bucket.
- Interacting with the API endpoints (`/list-bucket-content` and `/list-bucket-content/<path>`).
- Any other relevant demonstration of functionality.

Once you have created the video, upload it to a platform like **Google Drive**, **YouTube**, or **Vimeo**. Provide the link to the video below.

For example:

- [Video Demo on Google Drive](https://drive.google.com/file/d/1JPlmAG1BlIHJQ7wf0CoF1aVu4thshyRv/view?usp=sharing)

### 2. Word Documents:
- [Word Document 1 Link](https://docs.google.com/document/d/12JNZEOzs7JwKQ1iNH53X3gs3vZ97shSk/edit?usp=sharing&ouid=101179812942141955701&rtpof=true&sd=true)
- [Word Document 2 Link](https://docs.google.com/document/d/12JNZEOzs7JwKQ1iNH53X3gs3vZ97shSk/edit?usp=sharing&ouid=101179812942141955701&rtpof=true&sd=true)

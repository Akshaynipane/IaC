# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" # Replace with your desired region
}

# 1. Create the S3 bucket
resource "aws_s3_bucket" "public_bucket" {
  bucket = "my-unique-public-bucket-name-2025" # CRITICAL: Replace with a globally unique bucket name

  tags = {
    Name = "PublicS3Bucket"
  }
}

# 2. Configure Public Access Block settings
# By default, S3 blocks all public access. You must explicitly set these to false.
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.public_bucket.id

  block_public_acls       = True
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 3. Apply a bucket policy to allow public read access (s3:GetObject)
resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = aws_s3_bucket.public_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.public_bucket.arn}/*" # Allows access to all objects within the bucket
      }
    ]
  })
}

# Optional: Enable ACLs (needed for the "public-read" ACL setting)
# The bucket's object ownership must be set to "BucketOwnerPreferred" to use ACLs
resource "aws_s3_bucket_ownership_controls" "ownership_controls" {
  bucket = aws_s3_bucket.public_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Optional: Use the older ACL method for public read access (works in tandem with policy)
resource "aws_s3_bucket_acl" "public_read_acl" {
  # Depends on the ownership controls resource to avoid race conditions
  depends_on = [
    aws_s3_bucket_ownership_controls.ownership_controls,
    aws_s3_bucket_public_access_block.public_access_block,
  ]

  bucket = aws_s3_bucket.public_bucket.id
  acl    = "public-read"
}


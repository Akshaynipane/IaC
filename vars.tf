AWSTemplateFormatVersion: '2010-09-09'
Description: S3 bucket with public read ACL

Resources:
  PublicReadS3Bucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: your-unique-public-read-bucket-name # Replace with a globally unique bucket name
      AccessControl: PublicRead
      OwnershipControls:
        Rules:
          - ObjectOwnership: BucketOwnerPreferred # Or ObjectWriter, depending on your needs
      PublicAccessBlockConfiguration:
        BlockPublicAcls: false
        BlockPublicPolicy: false
        IgnorePublicAcls: false
        RestrictPublicBuckets: false

Outputs:
  BucketName:
    Description: Name of the S3 bucket
    Value: !Ref PublicReadS3Bucket

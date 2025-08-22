# Configure the AWS provider
provider "aws" {
  region = "eu-west-1"
Resources:
  MyEC2Instance:
    Type: AWS::EC2::Instance
    Properties:
      ImageId: ami-0abcdef1234567890 # Replace with a valid AMI ID for your region
      InstanceType: t2.micro
      MetadataOptions:
        HttpTokens: optional # This enables both IMDSv1 and IMDSv2
        HttpPutResponseHopLimit: 1 # Default value, can be adjusted if needed
      # ... other instance properties like KeyName, SecurityGroupIds, etc.
}

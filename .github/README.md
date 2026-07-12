# GitHub Actions deployment

Create these GitHub repository secrets before enabling the workflow:

- AWS_ROLE_TO_ASSUME
- S3_BUCKET_NAME
- CLOUDFRONT_DISTRIBUTION_ID (optional)

The workflow deploys the repository root to the target S3 bucket and invalidates the CloudFront distribution when a CloudFront ID is provided.

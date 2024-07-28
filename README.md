# AWS S3 bucket Terraform module

This terraform module will create a S3 bucket and a CloudFront distribution.
Also an origin access identity in our S3 bucket, through IAM and CloudFront.

## Usage

```hcl
provider "aws" {
  region = "us-east-2"
  profile = "project"
}

...

module "s3_bucket" {
  source  = "github.com/lhernerremon/module-s3-aws-terraform?ref=v1.0.0"
  project_name = "project"
  project_environment = "develop"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_name | Project's name | `string` | `""` | yes |
| project_environment | Project environment | `string` | `""` | yes |
| site_domain | Url of the site to be added to the S3 CORS. | `string` | `"*"` | no |
| cors_allowed_headers | Set of Headers that are specified in the `Access-Control-Request-Headers` header. | `list(string)` | `["*"]` | no |
| cors_allowed_methods | One or more HTTP methods that you allow the origin to execute. | `list(string)` | `["GET", "HEAD", "POST"]` | no |
| cors_expose_headers | One or more headers in the response that you want customers to be able to access from their applications. | `list(string)` | `[]` | no |
| cors_allowed_origins | Set of origins you want customers to be able to access the bucket from. | `list(string)` | `["*"]` | no |
| cors_max_age_seconds | The time in seconds that your browser is to cache the preflight response for the specified resource. | `number` | `3000` | no |
| policy_block_public_acls | If S3 block public ACLs. | `bool` | `false` | no |
| policy_ignore_public_acls | If S3 ignore public ACLs for this bucket. | `bool` | `false` | no |
| policy_block_public_policy | If S3 url of the site to be added to the S3 CORS. | `bool` | `false` | no |
| policy_restrict_public_buckets | If S3 should restrict public bucket policies for this bucket. | `bool` | `false` | no |
| price_class | CloudFront, price class for this distribution. | `string` | `PriceClass_100` | no |
| viewer_protocol_policy | CloudFront, protocol that users can use to access the files . | `string` | `redirect-to-https` | no |
| is_ipv6_enabled | CloudFront, whether the IPv6 is enabled for the distribution. | `bool` | `true` | no |
| compress | CloudFront, automatically compress content for web requests that include Accept-Encoding: gzip | `bool` | `false` | no |

## Outputs
| Name | Description|
|------|:--------:|
| bucket_name | The name og the bucket |

## Resources that return

| Extension | Folder | Description |
|------|-------------|:--------:|
| access_key.txt | ./api_key | Text file with the key to access the bucket through IAM |
| secret_key.txt | ./api_key | Text file with the secret key to the bucket using IAM |
| bucket_name.txt | ./api_key | Text file with the name of the S3 bucket |
| cloudfront_domain.txt | ./api_key | Text file with the domain name for CloudFront |

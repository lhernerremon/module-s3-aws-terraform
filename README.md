# AWS S3 bucket Terraform module

[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D%201.3.2-844FBA?logo=terraform&logoColor=white)](https://developer.hashicorp.com/terraform)
[![AWS provider](https://img.shields.io/badge/AWS%20provider-%3E%3D%205.58%2C%20%3C%207.0-FF9900)](https://registry.terraform.io/providers/hashicorp/aws/latest)
[![Amazon S3](https://img.shields.io/badge/Amazon%20S3-569A31)](https://aws.amazon.com/s3/)
[![Amazon CloudFront](https://img.shields.io/badge/Amazon%20CloudFront-8C4FFF)](https://aws.amazon.com/cloudfront/)

This Terraform module will create an S3 bucket, a CloudFront distribution in front of it and an IAM user whose access key can only work with that bucket.

The bucket has ACLs enabled (`BucketOwnerPreferred`), so the app decides per object: `public-read` for public files, `private` for the ones served through signed URLs. This is what django-storages does in cookiecutter-django.

CloudFront is only for the `public-read` objects. It has no Origin Access Control, so it reads the bucket anonymously and can't serve `private` ones. Signed URLs must point to the S3 domain: CloudFront strips the query string, and with it the signature. It caches with `Managed-CachingOptimized`, compresses text files and serves HTTP/2 and HTTP/3.

`cors_allowed_origins`, `cors_allowed_headers` and `cors_max_age_seconds` apply to both the bucket and CloudFront, so each environment has a single list of origins: `["*"]` for development, the frontend's domain for production.

## Usage

```hcl
provider "aws" {
  region  = "us-east-2"
  profile = "project"
}

module "s3_bucket" {
  source = "github.com/lhernerremon/module-s3-aws-terraform?ref=v2.0.0"

  project_name         = "project"
  project_environment  = "production"
  cors_allowed_origins = ["https://app.example.com"]
}
```

## Resources

| Resource                | Name                                                                    |
| ----------------------- | ----------------------------------------------------------------------- |
| S3 bucket               | `<project_name>-<project_environment>-s3`, lowercased, or `bucket_name` |
| CloudFront distribution | Tag `Name`: `<project_name>-<project_environment>-S3-CDN`               |
| CloudFront CORS policy  | `<project_name>-<project_environment>-S3-CORS`                          |
| IAM user                | `<project_name>-<project_environment>-S3-USER`                          |
| IAM group               | `<project_name>-<project_environment>-S3-GROUP`                         |
| IAM policy              | `<project_name>-<project_environment>-S3-POLICY`                        |

## Inputs

| Name                           | Description                                                                                  | Type           | Default                  | Required |
| ------------------------------ | -------------------------------------------------------------------------------------------- | -------------- | ------------------------ | :------: |
| project_name                   | Project's name                                                                               | `string`       |                          |   yes    |
| project_environment            | Project environment                                                                          | `string`       | `"development"`          |    no    |
| bucket_name                    | Name of the bucket. Bucket names are global, so set it if the default one is taken           | `string`       | `null`                   |    no    |
| cors_allowed_headers           | Headers allowed in the preflight request, by the bucket and CloudFront                       | `list(string)` | `["*"]`                  |    no    |
| cors_allowed_methods           | HTTP methods allowed by the bucket. CloudFront allows `GET`, `HEAD` and `OPTIONS`            | `list(string)` | `["GET", "HEAD", "PUT"]` |    no    |
| cors_expose_headers            | Headers the browser can read from the bucket responses                                       | `list(string)` | `[]`                     |    no    |
| cors_allowed_origins           | Origins allowed by the bucket and CloudFront. `["*"]` allows any                             | `list(string)` | `["*"]`                  |    no    |
| cors_max_age_seconds           | Seconds the browser caches the preflight response, for the bucket and CloudFront             | `number`       | `3000`                   |    no    |
| policy_block_public_acls       | Whether S3 rejects requests that set public ACLs. `true` breaks `public-read` uploads        | `bool`         | `false`                  |    no    |
| policy_ignore_public_acls      | Whether S3 ignores public ACLs. `true` makes `public-read` objects private                   | `bool`         | `false`                  |    no    |
| policy_block_public_policy     | Whether S3 rejects public bucket policies                                                    | `bool`         | `false`                  |    no    |
| policy_restrict_public_buckets | Whether S3 restricts public bucket policies for this bucket                                  | `bool`         | `false`                  |    no    |
| price_class                    | CloudFront, price class for this distribution                                                | `string`       | `"PriceClass_100"`       |    no    |
| viewer_protocol_policy         | CloudFront, protocol that users can use to access the files                                  | `string`       | `"redirect-to-https"`    |    no    |
| is_ipv6_enabled                | CloudFront, whether the IPv6 is enabled for the distribution                                 | `bool`         | `true`                   |    no    |
| compress                       | CloudFront, compresses text files (CSS, JS, JSON...) for requests that accept gzip or Brotli | `bool`         | `true`                   |    no    |

## Outputs

| Name                   | Description                           |
| ---------------------- | ------------------------------------- |
| bucket_name            | Name of the bucket                    |
| cloudfront_domain_name | Domain of the CloudFront distribution |

## Resources that return

| File                              | Folder    | Description                           |
| --------------------------------- | --------- | ------------------------------------- |
| `<project>_access_key.txt`        | ./api_key | Access key ID of the IAM user         |
| `<project>_secret_key.txt`        | ./api_key | Secret access key of the IAM user     |
| `<project>_bucket_name.txt`       | ./api_key | Name of the bucket                    |
| `<project>_cloudfront_domain.txt` | ./api_key | Domain of the CloudFront distribution |

`<project>` is `<project_name>-<project_environment>`.

**Note:** `<project>_secret_key.txt` and the `terraform.tfstate` hold the secret key in plain text. Keep both out of version control.

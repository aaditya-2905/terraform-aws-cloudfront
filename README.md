# Terraform AWS CloudFront Module

A **scalable, enterprise-grade Terraform module** to provision and manage AWS CloudFront distributions with full flexibility and simplicity.

This module is designed to be:

* 👶 **Beginner-friendly** (minimal inputs required)
* 🧑‍💻 **Advanced-ready** (full control over all CloudFront configurations)
* 🔐 **Secure by design** (supports Origin Access Control - OAC)
* 🧱 **Modular & clean** (root + internal module structure)

---

## 🚀 Features

* ✅ Create **CloudFront distributions with minimal configuration**
* ✅ **All variables exposed** (no hidden abstraction)
* ✅ Everything **optional with sensible defaults**
* ✅ Support for:

  * S3 origins (with OAC)
  * ALB / custom origins
  * Origin groups
* ✅ Built-in **Origin Access Control (OAC)** support
* ✅ Custom cache behaviors (default + ordered)
* ✅ Custom error responses
* ✅ Geo restrictions
* ✅ Response headers policy support
* ✅ Logging configuration
* ✅ VPC origin support
* ✅ Fully compatible with `terraform-aws-modules/cloudfront`

---

## 🧱 Module Structure

```
terraform-aws-cloudfront/
├── main.tf
├── variables.tf
├── outputs.tf
└── modules/
    └── cloudfront/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

## ⚙️ Usage

### 👶 Minimal Example (Beginner)

```hcl
module "cdn" {
  source = "aaditya-2905/cloudfront/aws"

  origin = {
    alb = {
      domain_name = module.alb.dns_name
      origin_id   = "alb-origin"
    }
  }

  default_cache_behavior = {
    target_origin_id       = "alb-origin"
    viewer_protocol_policy = "redirect-to-https"
  }
}
```

---

### 🧑‍💻 Advanced Example

```hcl
module "cdn" {
  source = "aaditya-2905/cloudfront/aws"

  aliases = ["app.example.com"]

  origin = {
    s3 = {
      domain_name = "my-bucket.s3.amazonaws.com"
      origin_id   = "s3-origin"
      oac_key     = "s3_oac"
    }
  }

  origin_access_control = {
    s3_oac = {
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  default_cache_behavior = {
    target_origin_id       = "s3-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
  }

  viewer_certificate = {
    cloudfront_default_certificate = true
  }

  restrictions = {
    geo_restriction = {
      restriction_type = "none"
    }
  }

  custom_error_response = [
    {
      error_code         = 404
      response_code      = 200
      response_page_path = "/index.html"
    }
  ]

  tags = {
    Environment = "dev"
    Project     = "cloudfront"
  }
}
```

---

## 🧠 How It Works

### 1. Clean Module Design

* Root module → passes variables
* Internal module → handles logic
* Uses official CloudFront module internally

---

### 2. Fully Optional Inputs

All variables:

* Have defaults
* Are optional
* Won’t break for beginners

---

### 3. Origin Access Control (OAC)

This module:

* Creates OAC dynamically
* Attaches it to S3 origins
* Enables secure private bucket access

---

## 🔐 S3 Bucket Policy (Required for OAC)

When using S3 origins:

```hcl
resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.example.id

  policy = jsonencode({
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.example.arn}/*"
      }
    ]
  })
}
```

---

## 📦 Inputs

| Name                    | Description                | Type         | Default |
| ----------------------- | -------------------------- | ------------ | ------- |
| aliases                 | Domain aliases             | list(string) | null    |
| origin                  | Origin configuration       | any          | `{}`    |
| origin_group            | Origin failover config     | any          | `{}`    |
| origin_access_control   | OAC config                 | any          | `{}`    |
| default_cache_behavior  | Default cache behavior     | any          | null    |
| ordered_cache_behavior  | Additional cache behaviors | any          | `[]`    |
| custom_error_response   | Custom error pages         | any          | `[]`    |
| restrictions            | Geo restrictions           | any          | null    |
| viewer_certificate      | SSL configuration          | any          | null    |
| response_headers_policy | Headers policy             | any          | null    |
| custom_headers          | Custom headers             | any          | `{}`    |
| logging_config          | Logging config             | any          | null    |
| log_delivery            | Advanced logging           | any          | null    |
| vpc_origin              | VPC origin support         | any          | null    |
| tags                    | Resource tags              | map(string)  | `{}`    |

---

## 📤 Outputs

| Name            | Description                |
| --------------- | -------------------------- |
| distribution_id | CloudFront Distribution ID |
| domain_name     | CloudFront Domain Name     |

---

## 🧪 Supported Use Cases

* Static websites (S3 + CloudFront)
* API delivery (ALB + ECS + CloudFront)
* Private content delivery using OAC
* Multi-origin routing
* Secure CDN with WAF integration

---

## ⚠️ Important Notes

* ACM certificate must be in **us-east-1**
* OAC requires proper S3 bucket policy
* Provide `origin_id` correctly (used in cache behavior)

---

## 🚀 Best Practices

* Use minimal config for simple setups
* Use ordered cache behaviors for APIs
* Enable logging in production
* Use OAC instead of public S3 access
* Integrate WAF for security

---

## 📈 Future Improvements

* Auto S3 bucket policy for OAC
* Lambda@Edge / CloudFront Functions
* Cache policy support (AWS managed)
* Advanced security headers

---

## 🤝 Contributing

Contributions are welcome:

* Add validation rules
* Improve variable typing
* Extend CloudFront feature coverage

---

## 📄 License

MIT License

module "template_files" {
  source = "hashicorp/dir/template"
  base_dir = "../web/react-app-frontend/build/"
  template_vars = {
    vpc_id = "vpc-abc123"
  }
}

resource "aws_s3_bucket" "this" {
    bucket = "lpnu-lazar-dev"
    tags = {
        Name = "S3 Bucket"
        Environment = "dev"
    }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "this" {
    bucket = aws_s3_bucket.this.id
    index_document {
      suffix = "index.html"
    }
    error_document {
      key = "index.html"
    }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = <<EOT
  {
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"AddPerm",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::${aws_s3_bucket.this.id}/*"]
    }
  ]
}
EOT
}

resource "aws_s3_object" "this" {
  for_each = module.template_files.files
  bucket = aws_s3_bucket.this.id
  key = each.key
  content_type = each.value.content_type
  source  = each.value.source_path
  content = each.value.content
  etag = each.value.digests.md5
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id = aws_s3_bucket.this.id
  }
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.this.id
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  tags = {
    Environment = "dev"
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
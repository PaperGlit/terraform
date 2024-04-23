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
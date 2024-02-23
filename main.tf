// My main terraform module
resource "aws_s3_bucket" "mywebsite" {
  bucket = var.bucketName
}

resource "aws_s3_bucket_website_configuration" "mywebsite-config" {
  bucket = aws_s3_bucket.mywebsite.bucket

  index_document {
    suffix = "index.html"
  }
  
}

resource "aws_s3_bucket_policy" "mywebsite-policy" {
  bucket = aws_s3_bucket.mywebsite.id
  policy = templatefile("mywebsite-s3-policy.json", { bucket = var.bucketName })
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
  
}

resource "aws_s3_object" "mywebsite-index" {
  bucket = aws_s3_bucket.mywebsite.id
  key    = "index.html"
  source = "src/index.html"
  acl    = "public-read"
  depends_on = [aws_s3_bucket_policy.mywebsite-policy]
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.mywebsite.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.example]
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mywebsite.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
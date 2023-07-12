resource "aws_s3_bucket" "mywebsite" {
  bucket = var.bucketName
}

resource "aws_s3_bucket_website_configuration" "mywebsite-config" {
  bucket = aws_s3_bucket.mywebsite.bucket
  index_document = {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "mywebsite-policy" {
  bucket = aws_s3_bucket.mywebsite.id
  policy = templatefile("s3-policy.json", { bucket = var.bucketName })
}

resource "aws_s3_object" "mywebsite-index" {
  bucket = aws_s3_bucket.example.id
  key    = "index.html"
  source = "../src/index.html"
  acl    = "public-read"
}

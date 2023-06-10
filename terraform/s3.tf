# Website content AWS S3 Terraform configuration

data "aws_iam_policy_document" "cloudfront_content_access" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.content.bucket}/*"]

    principals {
      identifiers = ["cloudfront.amazonaws.com"]
      type        = "Service"
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = ["arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.delivery.id}"]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.content.bucket}"]

    principals {
      identifiers = ["cloudfront.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_s3_bucket" "content" {
  bucket = "epicwink-website"
}

resource "aws_s3_bucket_policy" "content" {
  bucket = aws_s3_bucket.content.bucket
  policy = data.aws_iam_policy_document.cloudfront_content_access.json
}

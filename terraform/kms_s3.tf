#KMS Key and S3 buckets for staic and terraform state
resource "aws_kms_key" "main" {
  description = "${var.cluster_name} primary key"
  deletion_window_in_days = 30
  tags = {Name="${var.cluster_name}-kms"}
}

resource "aws_s3_bucket" "static" {
    bucket = "${var.cluster_name}-static-assets-${random_id.suffix.hex}"
    tags = {Name="${var.cluster_name}-static"}
  
}

resource "aws_s3_bucket_versioning" "static_versioning" {
    bucket=aws_s3_bucket.static.id
    versioning_configuration {
      status = "Enabled"
    }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "static_SSEC" {
    bucket = aws_s3_bucket.static.id
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
        kms_master_key_id = aws_kms_key.main.arn
      }
    }
}


resource "aws_s3_bucket" "tfstate" {
    bucket = "${var.cluster_name}-tfstate-assets-${random_id.suffix.hex}"
    tags = {Name="${var.cluster_name}-tfstate"}
  
}


resource "aws_s3_bucket_versioning" "tfstate_versioning" {
    bucket=aws_s3_bucket.tfstate.id
    versioning_configuration {
      status = "Enabled"
    }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate_SSEC" {
    bucket = aws_s3_bucket.tfstate.id
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
        kms_master_key_id = aws_kms_key.main.arn
      }
    }
}

resource "random_id" "suffix" {
    byte_length = 4
  
}
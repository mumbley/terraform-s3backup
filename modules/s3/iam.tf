resource "aws_iam_role" "s3backup" {
  name               = "dxps3backup-${var.deployment_name}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Principal": {
            "Federated": "${var.oidc_provider_arn}"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
            "StringEquals": {
                "${trimprefix(var.oidc_provider_url, "https://")}:sub": "system:serviceaccount:${var.namespace}:${var.deployment_name}-mongo-backup"
            }
        }
    }
  ]
}
EOF
}

resource "aws_iam_policy" "s3backup" {
  name        = "dxps3backup-${var.deployment_name}"
  description = "Policy to allow RW access to s3"
  policy      = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Action": "s3:ListAllMyBuckets",
         "Resource":"*"
      },
      {
         "Effect":"Allow",
         "Action": [
                "s3:ListBucketMultipartUploads",
                "s3:ListBucket",
                "s3:GetbucketLocation"
            ],
         "Resource":"${aws_s3_bucket.s3_bucket.arn}"
      },
      {
         "Effect":"Allow",
         "Action": [
                "s3:PutObjectAcl",
                "s3:PutObject",
                "s3:ListBucketMultipartUploads",
                "s3:GetObjectAcl",
                "s3:GetObject",
                "s3:AbortMultipartUploads"
            ],
         "Resource":"${aws_s3_bucket.s3_bucket.arn}/*"
      }
   ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3backup" {
  role       = aws_iam_role.s3backup.name
  policy_arn = aws_iam_policy.s3backup.arn
}


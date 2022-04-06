# Mongo S3 Backup

## Terraform module for backing up MongoDB to S3

This terraform module deploys a backup facility in a designated namespace and moves the backup file to AWS S3 storage for long term archive.

The deployment creates the following:

* AWS S3 bucket
* AWS S3 bucket policy
* AWS role with access to the policy that uses IRSA
* Kubernetes service account, role and rolebinding for accessing the IAM role using IRSA
* Kubernetes cronjob that performs the backup

There is also a dockerfile to use as the container that runs the cronjob.

For more iformation on how IRSA works see the documentation [here](https://aws.amazon.com/blogs/containers/cross-account-iam-roles-for-kubernetes-service-accounts/)

***

## Installation

Pull the repository and set your `main.tf` source to `<local path>/modules/s3`

```git clone git@gitlab-ssh.dxpcloud.net:steve/mongo-s3backup.git```


Alternatively, add the source to your `main.tf`using double slash to distinguish between the git repo and module folder and adding the tag or branch as a query (in this case, tag 1.0)

```
module "s3_backup_bucket" {
  source = "git::ssh://git@gitlab-ssh.dxpcloud.net/steve/mongo-s3backup//modules/s3?ref=1.0"
   ...
}
```

### Terraform variables

The variables required to configure the deployment are as follows:

var | type | description
--- | --- | ---
count | int | Set 1 to deploy and 0 to remove
schedule | string | backup schedule in cron format. Defaults to "1 0 * * *"
deployment_name | string | should match the deployment name of the DB to be backed up
s3_bucket_config | object | a set of variables for S3. See the next table for details
namespace | string | This should match the namespace of the DB to be backed up
oidc_provider_url| string | EKS OIDC providr URL
oidc_provider_arn | string | EKS OIDC provider ARN
mongodb | object | a set of variables for the Mongo database
accountid | string | currently unused. See below note

### Account ID (future feature)
The variable `accountid` is currently unused and will be used in future to derive the OIDC URL and ARN. For now set the following:

```
data "aws_caller_identity" "current" {}

module "s3_backup_bucket" {
  source = "the/path/of/the/module"
  accountid         = data.aws_caller_identity.current.account_id
         ...
}
```

### S3 Bucket Configuration Object
var | type | description
--- | --- | ---
name | string | bucket name without the deployment suffix
region | string | region to deploy the bucket
acl | string | Should be set to "private" unless you want public access to your backups
lifecycle_id | string | identifier for the bucket lifecycle (e.g. "backup")
enabled | bool | toggle the lifecycle rule
expiration_days | int | number of days to keep the backup file in S3
tags | object | a list of tags 

An example of the tags block:
```
tags = {
  "key1" = "value1"
  "key2" = "value2"
        ... 
}
```  

### MongoDB Configuraton Object
var | type | description
--- | --- | ---
service_name | string | the service name of the DB without the deployment prefix
port | string | IP port that the MongoDB service is listening on
database | string | name of the MongoDB dance abase to be backed up


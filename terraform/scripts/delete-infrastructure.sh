#!/bin/bash

TF_WORKSPACE="$1" # e.g. ec2
TF_BACKEND_S3_BUCKET_NAME="tf-backend-rgitoh"

# # Ensure S§ Bucket exists
# if [[ $(aws s3api list-buckets --query "Buckets[?Name=='$TF_BACKEND_S3_BUCKET_NAME'].Name" --output text) == "$TF_BACKEND_S3_BUCKET_NAME" ]] ; then
#     echo "S3 Bucket \"$TF_BACKEND_S3_BUCKET_NAME\" already exists."
# else
#     aws s3api create-bucket --bucket tf-backend-rgitoh --region eu-central-1 --acl private --create-bucket-configuration '{"LocationConstraint": "eu-central-1"}'
# fi

cd ./$1

echo -n "Terraform initializing... "
terraform init 1> /dev/null 
echo "done"
echo -n "Terraform planing... "
TF_PLAN=$(terraform plan -destroy -out plan.out -detailed-exitcode)
TF_STATUS_CODE="$?"
echo "done"
echo $TF_STATUS_CODE

if [ $TF_STATUS_CODE -eq 0 ] ; then
    echo "Everythings up-to-date."
elif [ $TF_STATUS_CODE -eq 2 ] ; then
    if [[ ! "$TF_PLAN" =~ "No changes" ]] ; then
        echo
        echo "$TF_PLAN"
        echo
        echo -n "Delete all infrastructure? [y/N] "
        read continue
        if [[ "$continue" =~ ^[Yy]$ ]] ; then
            terraform apply plan.out
            for secret in ec2/webserver/private-key ec2/webserver/public-key ; do
                aws secretsmanager delete-secret --force-delete-without-recovery --secret-id $secret
            done
            rm ../plan.out
        else
            echo "Aborted!"
        fi
    fi
fi

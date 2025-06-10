# SRE-Task Preconditions

## Toolstack

- ansible
- docker
- docker-compose

## Ansible

- `amazon.aws` collection:
    ```bash
    ansible-galaxy collection install amazon.aws
    ```
- `community.general` collection:
    ```bash
    ansible-galaxy collection install community.general
    ```

### Known Issues

#### objc[79826]: +[__NSCFConstantString initialize]
Reference: https://github.com/ansible/ansible/issues/76322

_Error_:
```bash
objc[79826]: +[__NSCFConstantString initialize] may have been in progress in another thread when fork() was called.
objc[79826]: +[__NSCFConstantString initialize] may have been in progress in another thread when fork() was called. We cannot safely call it or ignore it in the fork() child process. Crashing instead. Set a breakpoint on objc_initializeAfterForkError to debug.
ERROR! A worker was found in a dead state
```
_Solution_:
```
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
```

## AWS
- AWS Accoount: `723952339148`
- VPC:
    ```bash
    aws ec2 describe-vpcs --query Vpcs[0].VpcId --output text
    vpc-064c3eb0153d40a17
    ```
- Subnets:
    ```bash
    aws ec2 describe-subnets --query 'Subnets[].{"SubnetId": SubnetId, "CidrBlock": CidrBlock}'
    ```

    ```json
    [
        {
            "SubnetId": "subnet-00c70ef9b77b58b14",
            "CidrBlock": "172.31.32.0/20"
        },
        {
            "SubnetId": "subnet-0a97dbc8b332ad55c",
            "CidrBlock": "172.31.0.0/20"
        },
        {
            "SubnetId": "subnet-047b0723bbc77a18d",
            "CidrBlock": "172.31.16.0/20"
        }
    ]
    ```
- Github Token in AWS Secretsmanager:
    ```bash
    aws secretsmanager create-secret --name github-token --secret-string "github_pat_*****"
    ```

    ```bash
    aws secretsmanager list-secrets --query SecretList[].Name
    [
        "github-token"
    ]
    ```
### Steps

#### Install AWS CLI

```bash
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
```

#### Provision EC2 instance

The following resources are required:

- Security Group
- Private Subnet
- Internet Gateway

Used tool: **Terraform**

> [!NOTE]
> Folder structure
> ```bash
> terraform
> └── ec2
>    ├── config.tf
>    ├── ec2-key-ansible.pem
>    ├── ec2-key-webserver.pem
>    ├── ec2-webserver-keypair.tf
>    ├── ec2-webserver.tf
>    ├── elastic-ip.tf
>    ├── main.tf
>    ├── outputs.tf
>    ├── plan.out
>    ├── security_group_webserver.tf
>    ├── terraform.tfstate
>    ├── terraform.tfstate.backup
>    └── userdata
>        └── webserver-userdata.sh
>
> 3 directories, 13 files
>```

#### Get EC2 Private Key from AWS Secretsmanager

```bash
aws secretsmanager get-secret-value --secret-id ec2-private-key --query SecretString --output text > ec2-key.pem && chmod 600 ec2-key.pem
```

### Get EC2 Instance details

```bash
aws ec2 describe-instances --query 'Reservations[].Instances[?State.Name==`running`].{"InstanceId": InstanceId,PublicDnsName: PublicDnsName,PublicIpAddress: PublicIpAddress}'
```

```json
[
    {
        "InstanceId": "i-083bbc000527fa9b5",
        "PublicDnsName": "ec2-63-178-42-193.eu-central-1.compute.amazonaws.com",
        "PublicIpAddress": "63.178.42.193"
    }
]
```

### Connect to EC2 Instance

#### SSH

tbd

#### AWS CLI

```bash
aws ec2-instance-connect ssh --instance-id i-083bbc000527fa9b5 --private-key-file ec2-key.pem
```

### Delete EC2 instance and infrastructure

```bash
terraform plan -destroy -out=plan.out
terraform apply
for secret in ec2/webserver/private-key ec2/webserver/public-key ; do aws secretsmanager delete-secret --force-delete-without-recovery --secret-id $secret ; done
```

> [!NOTE]
> The permanent deletion of secrets in AWS Secretsmanager can take several minutes!
import json
import boto3
import requests
from botocore.exceptions import ClientError

# Basic config for the deployed lab environment.
# These values match the Terraform deployment unless changed later.
REGION = "us-west-2"
DOMAIN = "http://tetsuzai-kube.com"
SECRET_NAME = "lab1-redone/rds/mysql"

ec2 = boto3.client("ec2", region_name=REGION)
rds = boto3.client("rds", region_name=REGION)
secrets = boto3.client("secretsmanager", region_name=REGION)
iam = boto3.client("iam")

results = []


def record_result(name, passed, details=""):
    status = "PASS" if passed else "FAIL"
    print(f"{status}: {name}")
    if details:
        print(f"      {details}")

    results.append({
        "check": name,
        "passed": passed,
        "details": details
    })


# --------------------------------------------------
# EC2 Validation
# --------------------------------------------------
try:
    instances = ec2.describe_instances(
        Filters=[
            {"Name": "tag:Name", "Values": ["lab1-redone-app-server"]},
            {"Name": "instance-state-name", "Values": ["running"]}
        ]
    )

    reservations = instances["Reservations"]

    if reservations:
        instance = reservations[0]["Instances"][0]
        record_result("EC2 instance is running", True)

        if "IamInstanceProfile" in instance:
            record_result("IAM instance profile attached", True)
        else:
            record_result("IAM instance profile attached", False)

    else:
        record_result("EC2 instance is running", False)

except Exception as e:
    record_result("EC2 validation", False, str(e))


# --------------------------------------------------
# Secrets Manager Validation
# --------------------------------------------------
try:
    secret = secrets.describe_secret(SecretId=SECRET_NAME)
    record_result("Secrets Manager secret exists", True)

except ClientError as e:
    record_result("Secrets Manager secret exists", False, str(e))


# --------------------------------------------------
# RDS Validation
# --------------------------------------------------
try:
    dbs = rds.describe_db_instances()["DBInstances"]

    if dbs:
        db = dbs[0]

        if not db["PubliclyAccessible"]:
            record_result("RDS is private", True)
        else:
            record_result("RDS is private", False)

    else:
        record_result("RDS instance exists", False)

except Exception as e:
    record_result("RDS validation", False, str(e))


# --------------------------------------------------
# HTTP / App Validation
# --------------------------------------------------
try:
    home = requests.get(DOMAIN, timeout=10)
    record_result("Home page reachable", home.status_code == 200)

    init_resp = requests.get(f"{DOMAIN}/init", timeout=10)
    record_result("/init endpoint works", init_resp.status_code == 200)

    test_note = "validation_note"

    add_resp = requests.get(
        f"{DOMAIN}/add?note={test_note}",
        timeout=10
    )
    record_result("/add endpoint works", add_resp.status_code == 200)

    list_resp = requests.get(f"{DOMAIN}/list", timeout=10)

    if test_note in list_resp.text:
        record_result("/list contains inserted note", True)
    else:
        record_result("/list contains inserted note", False)

except Exception as e:
    record_result("HTTP endpoint validation", False, str(e))


# --------------------------------------------------
# Save Validation Report
# --------------------------------------------------
with open("lab1a_validation.json", "w") as f:
    json.dump(results, f, indent=2)

print("\nValidation report written to lab1a_validation.json")
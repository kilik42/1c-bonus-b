import json
import boto3
from botocore.exceptions import ClientError

# Basic config for the Lab 1B validation checks.
# These values match the resources created in the rebuilt lab.
REGION = "us-west-2"
PROJECT_NAME = "lab1-redone"

SSM_PARAMETER_NAMES = [
    f"/{PROJECT_NAME}/db/endpoint",
    f"/{PROJECT_NAME}/db/port",
    f"/{PROJECT_NAME}/db/name",
]

SNS_TOPIC_NAME = f"{PROJECT_NAME}-ops-alerts"
ALARM_NAME = f"{PROJECT_NAME}-alb-unhealthy-hosts"

ssm = boto3.client("ssm", region_name=REGION)
sns = boto3.client("sns", region_name=REGION)
cloudwatch = boto3.client("cloudwatch", region_name=REGION)

results = []


def record_result(name: str, passed: bool, details: str = "") -> None:
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
# SSM Parameter Validation
# --------------------------------------------------
try:
    resp = ssm.get_parameters(
        Names=SSM_PARAMETER_NAMES,
        WithDecryption=False
    )

    found_names = {param["Name"] for param in resp.get("Parameters", [])}
    invalid_names = resp.get("InvalidParameters", [])

    for param_name in SSM_PARAMETER_NAMES:
        if param_name in found_names:
            record_result(f"SSM parameter exists: {param_name}", True)
        else:
            reason = "Missing from Parameter Store"
            if param_name in invalid_names:
                reason = "Reported as invalid/missing by AWS"
            record_result(f"SSM parameter exists: {param_name}", False, reason)

except ClientError as e:
    record_result("SSM parameter validation", False, str(e))


# --------------------------------------------------
# SNS Topic Validation
# --------------------------------------------------
topic_arn = None

try:
    next_token = None
    all_topics = []

    while True:
        kwargs = {}
        if next_token:
            kwargs["NextToken"] = next_token

        resp = sns.list_topics(**kwargs)
        all_topics.extend(resp.get("Topics", []))
        next_token = resp.get("NextToken")

        if not next_token:
            break

    for topic in all_topics:
        arn = topic["TopicArn"]
        if arn.endswith(f":{SNS_TOPIC_NAME}"):
            topic_arn = arn
            break

    if topic_arn:
        record_result("SNS topic exists", True, topic_arn)
    else:
        record_result("SNS topic exists", False, f"Topic not found: {SNS_TOPIC_NAME}")

except ClientError as e:
    record_result("SNS topic validation", False, str(e))


# --------------------------------------------------
# SNS Subscription Validation
# --------------------------------------------------
if topic_arn:
    try:
        next_token = None
        subscriptions = []

        while True:
            kwargs = {"TopicArn": topic_arn}
            if next_token:
                kwargs["NextToken"] = next_token

            resp = sns.list_subscriptions_by_topic(**kwargs)
            subscriptions.extend(resp.get("Subscriptions", []))
            next_token = resp.get("NextToken")

            if not next_token:
                break

        if subscriptions:
            confirmed = False
            for sub in subscriptions:
                endpoint = sub.get("Endpoint", "Unknown")
                protocol = sub.get("Protocol", "Unknown")
                arn = sub.get("SubscriptionArn", "PendingConfirmation")

                if arn != "PendingConfirmation":
                    confirmed = True
                    record_result(
                        "SNS subscription confirmed",
                        True,
                        f"{protocol} -> {endpoint}"
                    )
                    break

            if not confirmed:
                record_result(
                    "SNS subscription confirmed",
                    False,
                    "Subscription exists but is still pending confirmation"
                )
        else:
            record_result("SNS subscription confirmed", False, "No subscriptions found for topic")

    except ClientError as e:
        record_result("SNS subscription validation", False, str(e))


# --------------------------------------------------
# CloudWatch Alarm Validation
# --------------------------------------------------
try:
    resp = cloudwatch.describe_alarms(AlarmNames=[ALARM_NAME])
    alarms = resp.get("MetricAlarms", [])

    if alarms:
        alarm = alarms[0]
        state = alarm.get("StateValue", "UNKNOWN")

        record_result("CloudWatch alarm exists", True, ALARM_NAME)
        record_result(
            "CloudWatch alarm state is readable",
            True,
            f"Current state: {state}"
        )
    else:
        record_result("CloudWatch alarm exists", False, f"Alarm not found: {ALARM_NAME}")

except ClientError as e:
    record_result("CloudWatch alarm validation", False, str(e))


# --------------------------------------------------
# Write Report
# --------------------------------------------------
output_file = "lab1b_validation.json"

with open(output_file, "w", encoding="utf-8") as f:
    json.dump(results, f, indent=2)

print(f"\nValidation report written to {output_file}")
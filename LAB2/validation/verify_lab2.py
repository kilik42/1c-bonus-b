import boto3
import json

REGION = "us-west-2"

cloudfront = boto3.client("cloudfront")
route53 = boto3.client("route53")
acm = boto3.client("acm", region_name="us-east-1")
elbv2 = boto3.client("elbv2", region_name=REGION)

results = []

def record(status, message, details=None):
    results.append({
        "status": status,
        "message": message,
        "details": details
    })
    print(f"{status}: {message}")
    if details:
        print(f"    {details}")


# --------------------------------------------------
# Check CloudFront Distribution
# --------------------------------------------------
distros = cloudfront.list_distributions().get("DistributionList", {}).get("Items", [])

target_dist = None
for d in distros:
    aliases = d.get("Aliases", {}).get("Items", [])
    if "app.tetsuzai-kube.com" in aliases:
        target_dist = d
        break

if target_dist:
    record("PASS", "CloudFront distribution exists", target_dist["Id"])
else:
    record("FAIL", "CloudFront distribution missing")


# --------------------------------------------------
# Check ACM Certificate
# --------------------------------------------------
certs = acm.list_certificates(CertificateStatuses=["ISSUED"])["CertificateSummaryList"]

cert_found = False
for cert in certs:
    if cert["DomainName"] == "app.tetsuzai-kube.com":
        cert_found = True
        record("PASS", "ACM certificate exists", cert["CertificateArn"])
        break

if not cert_found:
    record("FAIL", "ACM certificate missing")


# --------------------------------------------------
# Check Route53 Alias
# --------------------------------------------------
zones = route53.list_hosted_zones()["HostedZones"]

for zone in zones:
    records = route53.list_resource_record_sets(HostedZoneId=zone["Id"])["ResourceRecordSets"]
    for r in records:
        if r["Name"].rstrip(".") == "app.tetsuzai-kube.com":
            record("PASS", "Route53 alias exists", r["Name"])
            break


# --------------------------------------------------
# Check ALB Exists
# --------------------------------------------------
lbs = elbv2.describe_load_balancers()["LoadBalancers"]

alb_found = False
for lb in lbs:
    if "lab1-redone-alb" in lb["LoadBalancerName"]:
        alb_found = True
        record("PASS", "ALB exists", lb["LoadBalancerArn"])
        break

if not alb_found:
    record("FAIL", "ALB missing")


# --------------------------------------------------
# Save JSON Report
# --------------------------------------------------
with open("lab2_validation.json", "w") as f:
    json.dump(results, f, indent=2)

print("\nValidation report written to lab2_validation.json")
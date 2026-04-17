import json
from pathlib import Path

# LAB3B validation checks that the audit/evidence pack exists.
# This script validates the documentation side of LAB3 after LAB3A infrastructure has already been verified.

BASE_DIR = Path(__file__).resolve().parent.parent
AUDIT_PACK_DIR = BASE_DIR / "audit-pack"
DOCS_DIR = BASE_DIR / "docs"
VALIDATION_DIR = BASE_DIR / "validation"

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


def file_exists(path: Path, description: str) -> None:
    if path.exists():
        record_result(description, True, str(path))
    else:
        record_result(description, False, f"Missing: {path}")


# --------------------------------------------------
# Required validation artifacts
# --------------------------------------------------
file_exists(VALIDATION_DIR / "verify_lab3a.py", "LAB3A validator exists")
file_exists(VALIDATION_DIR / "lab3a_validation.json", "LAB3A validation JSON exists")
file_exists(VALIDATION_DIR / "validation_terminal_output.txt", "LAB3A terminal output exists")

# --------------------------------------------------
# Required LAB3 docs
# --------------------------------------------------
file_exists(AUDIT_PACK_DIR / "00_architecture-summary.md", "LAB3 architecture summary exists")
file_exists(DOCS_DIR / "lab3_notes.md", "LAB3 notes file exists")

# --------------------------------------------------
# Expected screenshots / evidence
# --------------------------------------------------
expected_screenshots = [
    AUDIT_PACK_DIR / "01_primary_tgw.png",
    AUDIT_PACK_DIR / "02_secondary_tgw.png",
    AUDIT_PACK_DIR / "03_tgw_peering.png",
    AUDIT_PACK_DIR / "04_tokyo_route.png",
    AUDIT_PACK_DIR / "05_saopaulo_route.png",
]

all_screenshots_present = True
for screenshot in expected_screenshots:
    if screenshot.exists():
        record_result(f"Screenshot exists: {screenshot.name}", True, str(screenshot))
    else:
        all_screenshots_present = False
        record_result(f"Screenshot exists: {screenshot.name}", False, f"Missing: {screenshot}")

record_result(
    "All required LAB3 audit screenshots exist",
    all_screenshots_present,
    f"{sum(1 for p in expected_screenshots if p.exists())}/{len(expected_screenshots)} present"
)

# --------------------------------------------------
# Write validation report
# --------------------------------------------------
output_file = VALIDATION_DIR / "lab3b_validation.json"

with open(output_file, "w", encoding="utf-8") as f:
    json.dump(results, f, indent=2)

print(f"\nValidation report written to {output_file}")
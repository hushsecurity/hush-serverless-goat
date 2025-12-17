# Hush Security Serverless Demo

This project demonstrates the Hush solution for serverless (AWS lambda) deployment.

---

## Demo Steps

### Phase 1: Setup
1. **Action**: Run the Terraform to deploy an AWS Secret and a Lambda function:
   ```bash
   terraform init
   terraform apply -auto-approve
2. **Action**: Clone this repository.
3. **Action**: In the Hush UI, create a Git integration with this repo
4. **Action**: In the Hush UI, create a Serverless deployment with the new lambda

### Phase 2: Static Detection (Severity: Low)
1. **Result**: Hush scans the code, identifies the hard-coded secret, and flags it as a **Low Severity** finding.

### Phase 3: Active Threat (Severity: High)
1. **Action**: Trigger the Lambda to simulate a serverless execution with an authentication attempt:
   ```bash
   aws lambda invoke --function-name hush_goat_lambda out.json
2. **Result**: The secret’s status is automatically upgraded to High Severity (Active Leak).

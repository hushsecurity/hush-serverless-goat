import json
import boto3
import requests

client = boto3.client("secretsmanager")


def lambda_handler(event, context):
    try:
        secret = client.get_secret_value(SecretId="hush/goat/secret")["SecretString"]
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps(f"Error retrieving secret: {str(e)}"),
        }

    auth_url = "https://api.hubapi.com/crm/v3/objects/contacts"
    headers = {"Authorization": f"Bearer {secret}", "Content-Type": "application/json"}
    try:
        requests.get(auth_url, headers=headers)
    except Exception:
        pass

    return {"statusCode": 200, "body": json.dumps("Demo execution complete.")}

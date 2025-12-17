import json
import requests

# Triggers 'Low' severity detection upon Git scan
HUBSPOT_PAT = "pat-na1-ffbb9f50-d96b-4abc-84f1-b986617be1b5"

def lambda_handler(event, context):
    # 1. Triggers 'High' severity detection upon auth event
    auth_url = "https://api.hubapi.com/crm/v3/objects/contacts"
    headers = {
        "Authorization": f"Bearer {HUBSPOT_PAT}",
        "Content-Type": "application/json"
    }
    try:
        requests.get(auth_url, headers=headers)
    except Exception:
        pass

    return {
        "statusCode": 200,
        "body": json.dumps("Demo execution complete.")
    }

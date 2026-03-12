import json
import boto3
import os
import uuid
from datetime import datetime

s3 = boto3.client("s3")
dynamodb = boto3.resource("dynamodb")

TABLE_NAME = os.environ["TABLE_NAME"]
TEMPLATE_BUCKET = os.environ["TEMPLATE_BUCKET"]

table = dynamodb.Table(TABLE_NAME)


def get_template(template_name):
    try:
        response = s3.get_object(
            Bucket=TEMPLATE_BUCKET,
            Key=f"{template_name}.html"
        )
        return response["Body"].read().decode("utf-8")
    except Exception as e:
        print(f"Error obteniendo template {template_name}.html:", e)
        return None


def replace_variables(template, data):
    for key, value in data.items():
        template = template.replace(f"{{{{{key}}}}}", str(value))
    return template


def lambda_handler(event, context):

    print("EVENT:", json.dumps(event))

    for record in event["Records"]:

        message = json.loads(record["body"])
        print("MESSAGE:", message)

        if "type" in message:
            notification_type = message["type"]
            data = message["data"]

        elif "request" in message:
            notification_type = message["request"]
            data = {"userId": message["userId"]}

        else:
            print("Mensaje desconocido:", message)
            continue

        template = get_template(notification_type)

        if not template:
            print("Template no encontrado:", notification_type)
            continue

        body = replace_variables(template, data)

        print("EMAIL BODY:")
        print(body)

        table.put_item(
            Item={
                "uuid": str(uuid.uuid4()),
                "createdAt": datetime.utcnow().isoformat(),
                "type": notification_type,
                "data": data
            }
        )

    return {"statusCode": 200}
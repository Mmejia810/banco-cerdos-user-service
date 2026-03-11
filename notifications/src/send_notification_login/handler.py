import boto3, json, os

s3 = boto3.client("s3")
BUCKET_NAME = os.environ.get("TEMPLATE_BUCKET", "templates-email-notification")

def handler(event, context):
    for record in event["Records"]:
        body = json.loads(record["body"])
        data = body["data"]

        template = s3.get_object(Bucket=BUCKET_NAME, Key="login.html")["Body"].read().decode("utf-8")
        message = template.replace("{{date}}", data["date"])
        print(f"[EMAIL] USER.LOGIN:\n{message}")

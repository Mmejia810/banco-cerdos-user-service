import json
import boto3
import os

dynamodb = boto3.resource('dynamodb')
TABLE_NAME = os.environ.get('TABLE_NAME', 'users-table')
table = dynamodb.Table(TABLE_NAME)

def lambda_handler(event, context):
    try:
      
        user_id = event['pathParameters']['user_id']
        
    
        body = json.loads(event['body'])
        address = body.get('address')
        phone = body.get('phone')

      
        table.update_item(
            Key={'uuid': user_id}, 
            UpdateExpression="set dirección=:a, teléfono=:p",
            ExpressionAttributeValues={
                ':a': address,
                ':p': phone
            },
            ReturnValues="UPDATED_NEW"
        )

        return {
            "statusCode": 200,
            "body": json.dumps({"message": "Perfil actualizado correctamente"})
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
import json
import boto3
import os

dynamodb = boto3.resource('dynamodb')
# Usamos el nombre de la tabla desde la variable de entorno de Terraform
table = dynamodb.Table(os.environ.get('TABLE_NAME', 'users-table'))

def lambda_handler(event, context):
    try:
        # Extraer parámetros de la ruta (Path Parameters)
        user_id = event['pathParameters']['user_id']
        documento = event['pathParameters']['documento']
        
        body = json.loads(event['body'])
        
        # Actualización usando alias para evitar errores por tildes
        table.update_item(
            Key={'uuid': user_id, 'documento': documento},
            UpdateExpression="set nombre=:n, apellido=:a, #dir=:d, #tel=:p",
            ExpressionAttributeNames={
                "#dir": "dirección",
                "#tel": "teléfono"
            },
            ExpressionAttributeValues={
                ':n': body.get('name', 'Sin Nombre'),
                ':a': body.get('lastName', 'Sin Apellido'),
                ':d': body.get('address', ''),
                ':p': body.get('phone', '')
            }
        )
        return {
            "statusCode": 200,
            "body": json.dumps({"message": "Perfil actualizado con éxito"})
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
# 🐷 Banco Cerdos - User Service

Este microservicio se encarga del registro de usuarios en la plataforma de Banco Cerdos. Utiliza una arquitectura Serverless en AWS gestionada con Terraform.

## 🚀 Arquitectura
* **API Gateway**: Punto de entrada (REST API) para las peticiones externas.
* **AWS Lambda**: Función en Python 3.9 que procesa la lógica de registro.
* **DynamoDB**: Tabla NoSQL (`users-table`) donde se almacena la información.
* **SQS**: Cola para peticiones de creación de tarjetas físicas/virtuales.

## 🛠️ Requisitos Previos
1. Tener instalado [Terraform](https://www.terraform.io/downloads).
2. Tener configurado [AWS CLI](https://aws.amazon.com/cli/) con credenciales en la región `us-east-1`.
3. Python 3.9 o superior.

## 📦 Despliegue

1. **Preparar el código de la Lambda:**
   Ve a la carpeta `src` y comprime el archivo:
   ```powershell
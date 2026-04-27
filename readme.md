banco-cerdos-user-service
Microservicios de la plataforma Banco Cerdo encargados del registro y gestión de usuarios, tarjetas, transacciones y notificaciones. Arquitectura serverless en AWS gestionada con Terraform.

Servicios
ServicioResponsabilidaduser-serviceRegistro, login, perfil y actualización de usuarioscard-serviceGestión de tarjetas débito y créditotransaction-serviceProcesamiento de transacciones bancariasnotifications-serviceEnvío de notificaciones y alertas

Stack

AWS Lambda
AWS API Gateway
Terraform
Node.js
JWT


Arquitectura
AWS API Gateway
      |
  ----+--------------------+------------------+
  |                        |                  |
user-service          card-service   transaction-service
                                              |
                                  notifications-service
Cada servicio corre como una función Lambda independiente. La infraestructura está declarada como código con Terraform, lo que permite reproducir el entorno completo con un solo comando.

Despliegue
bashterraform init
terraform plan
terraform apply

Repositorios relacionados

Frontend: Banco_cerdo_fronted
Flujo de pagos: banco-cerdos-payment-flow


Autor
Mauricio José Mejía Morales — github.com/Mmejia810

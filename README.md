# Proyecto AWS Reto: Despliegue de una Instancia EC2 con Packer, Ansible y Terraform

Descripción

Este repositorio contiene los archivos necesarios para crear una AMI en AWS utilizando Packer, aprovisionarla con Ansible, y desplegar una instancia EC2 con Terraform. La AMI generada tendrá instalado el servidor web Apache y mostrará una página con el mensaje "Hola Mundo desde AWS".

Tecnologías Utilizadas:

- AWS EC2

- Packer

- Ansible

- Terraform

- Bash Scripting

Requisitos Previos

Antes de ejecutar este proyecto, asegúrate de tener instalado:

-AWS CLI configurado con credenciales válidas

-Packer

-Ansible

-Terraform

-Bash

Nota: También se necesita una VPC y una key pair en AWS.

Estructura del Repositorio.
![image](https://github.com/user-attachments/assets/da14980d-3522-4eac-9b9c-1ad1ddcf42ce)


Pasos para Ejecutar el Proyecto

Pasos para Ejecutar el Proyecto

1. Crear la AMI con Packer

Ejecutar el siguiente comando:

packer build packer/packer-template.json

Este comando generará una AMI basada en Ubuntu 22.04 con Apache preinstalado.

2. Obtener el ID de la AMI creada

Para verificar que la AMI fue creada correctamente, usa:

aws ec2 describe-images --owners self --filters "Name=name,Values=ubuntu-22-04-apache-*" --query "Images[*].ImageId"

Toma nota del AMI ID generado.

3. Desplegar la AMI en una EC2 con Terraform

Edita el archivo terraform/main.tf y reemplaza el valor de ami_id con el ID de la AMI creada. Luego, ejecuta:

cd terraform
terraform init
terraform apply -auto-approve

Esto creará una nueva instancia EC2 utilizando la AMI generada.

4. Obtener la IP Pública de la Instancia

terraform output public_ip

Accede a la IP en tu navegador:

http://<IP_PÚBLICA>

Deberías ver la página con el mensaje "Hola Mundo desde AWS".
por ejemplo en mi caso: 
http://3.89.90.52/

5. Automatizar con Bash

Para ejecutar todo el proceso de forma automática, usa:

bash scripts/deploy.sh

Esto realizará todos los pasos anteriores de manera automatizada. 

Nota: si quiere ver el resultado en consola puedes usar el siguiente comando: cat /var/www/html/index.html

Notas

Asegúrate de tener los permisos adecuados en AWS para crear y gestionar instancias EC2.

Puedes modificar el contenido de index.html dentro de playbook.yml si deseas personalizar la página web.

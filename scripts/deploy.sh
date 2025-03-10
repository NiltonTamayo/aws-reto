#!/bin/bash

# Variables
REGION="us-east-1"
INSTANCE_TYPE="t2.micro"
PACKER_TEMPLATE="packer/packer-template.json"
TERRAFORM_DIR="terraform"

# Verificar dependencias
command -v packer >/dev/null 2>&1 || { echo "Packer no está instalado. Instálalo primero."; exit 1; }
command -v terraform >/dev/null 2>&1 || { echo "Terraform no está instalado. Instálalo primero."; exit 1; }
command -v aws >/dev/null 2>&1 || { echo "AWS CLI no está instalado. Instálalo primero."; exit 1; }

# Paso 1: Crear la AMI con Packer
echo "Creando AMI con Packer..."
packer build $PACKER_TEMPLATE

if [ $? -ne 0 ]; then
  echo "Error: Packer no pudo crear la AMI."
  exit 1
fi

# Paso 2: Obtener el ID de la AMI creada
echo "Obteniendo el ID de la AMI..."
AMI_ID=$(aws ec2 describe-images --owners self --filters "Name=name,Values=ubuntu-22-04-apache-*" --query "Images | sort_by(@, &CreationDate) | [-1].ImageId" --output text)

if [ -z "$AMI_ID" ]; then
  echo "Error: No se pudo obtener el ID de la AMI."
  exit 1
fi

echo "AMI creada con ID: $AMI_ID"

# Paso 3: Desplegar la AMI con Terraform
echo "Desplegando la AMI con Terraform..."
cd $TERRAFORM_DIR || { echo "Error: No se pudo cambiar al directorio $TERRAFORM_DIR"; exit 1; }

terraform init
if [ $? -ne 0 ]; then
  echo "Error: Terraform init falló."
  exit 1
fi

terraform apply -auto-approve -var "ami_id=$AMI_ID"
if [ $? -ne 0 ]; then
  echo "Error: Terraform apply falló."
  exit 1
fi

echo "¡Despliegue completado con éxito!"
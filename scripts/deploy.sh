#!/bin/bash

# Paso 1: Crear la AMI con Packer
echo "Creando AMI con Packer..."
packer build packer/packer-template.json

# Obtener el ID de la AMI creada
AMI_ID=$(aws ec2 describe-images --owners self --filters "Name=name,Values=ubuntu-22-04-apache-*" --query "Images | sort_by(@, &CreationDate) | [-1].ImageId" --output text)
echo "AMI creada con ID: $AMI_ID"

# Paso 2: Desplegar la AMI con Terraform
echo "Desplegando la AMI con Terraform..."
cd terraform
terraform init
terraform apply -auto-approve -var "ami_id=$AMI_ID"

# Paso 3: Mostrar la IP pública de la instancia
echo "La IP pública de la instancia es:"
terraform output public_ip

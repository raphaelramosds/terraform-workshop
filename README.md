# Terraform Workshop

## Visão geral

Este repositório contém exemplos e exercícios práticos para o treinamento de Terraform. Ele abrange desde conceitos básicos até tópicos avançados, incluindo o uso de providers, módulos, backends remotos e boas práticas de organização de infraestrutura como código na Google Cloud Platform.

## Programa

[![Notion](https://img.shields.io/badge/Notion-000000?style=flat-square&logo=notion&logoColor=white)](https://grass-basket-1ee.notion.site/Treinamento-Terraform-330d3a700afe800e80d4e32afcfbee60?pvs=74) **Conteúdo do treinamento**
- Página no Notion com todo o conteúdo do treinamento
- Nela estão explicações das implementações presentes neste repositório

[![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat-square&logo=terraform&logoColor=white)](./00_local_provider/) **Primeiros passos com o provider local**
- Introdução ao Terraform com o provider `hashicorp/local`
- Demonstra o ciclo básico de init, plan e apply criando um arquivo local

[![GCP](https://img.shields.io/badge/GCP-4285F4?style=flat-square&logo=googlecloud&logoColor=white)](./01_fn_send_email/) **Cloud Function para envio de e-mails via SMTP**
- Provisionamento de uma Cloud Function (2ª geração) em Python
- Inclui bucket GCS para o código-fonte, service account e IAM público
- Configuração de backend remoto no GCS para gerenciamento de estado

[![GCP](https://img.shields.io/badge/GCP-4285F4?style=flat-square&logo=googlecloud&logoColor=white)](./02_fn_send_email_refactor/) **Refatoração com módulos e ambientes**
- Reorganização da Cloud Function em um módulo reutilizável (`services/`)
- Separação de responsabilidades: `main.tf`, `buckets.tf` e `variables.tf`
- Ambientes isolados (`dev`, `staging`, `prod`) com backends e tfvars independentes

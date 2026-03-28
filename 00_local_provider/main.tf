terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

resource "local_file" "exemplo_config" {
  content  = "Este arquivo foi gerado pelo Terraform!\nAmbiente: Produção\nID do Recurso: 12345"
  filename = "${path.module}/configuracao.txt"
  file_permission = "0600"
}

output "caminho_do_arquivo" {
  value = local_file.exemplo_config.filename
}
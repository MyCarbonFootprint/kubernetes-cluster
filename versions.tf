terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "1.3.2"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "1.13.3"
    }
  }
}


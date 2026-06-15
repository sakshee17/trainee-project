// Remote backend configured per-environment via -backend-config or backend HCL files.
// Do NOT hardcode environment-specific backend values here.
terraform {
  backend "azurerm" {}
}
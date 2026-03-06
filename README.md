# Azure Hub-Spoke Secure Landing Zone Project

Infrastructure-as-Code deployment of a hub-spoke network topology on Azure using Terraform. Designed following Microsoft's Cloud Adoption Framework and Azure landing zone best practices.

## Architecture
<img width="8192" height="1682" alt="Azure VNet Hub-Spoke-2026-03-06-182133" src="https://github.com/user-attachments/assets/ec21bd1c-0903-4e2a-850e-fcecfdb7cdbc" />

## Overview

This project deploys a secure landing zone with centralized network security through a hub-spoke model. All ingress traffic flows through an Application Gateway with WAF, application workloads run in isolated spoke VNets, database access is restricted to private endpoints, and all egress traffic routes through a centralized Azure Firewall.

## Resources Deployed

### Hub (hub-rg)

| Resource | Name | Purpose |
|----------|------|---------|
| Virtual Network | hub-vnet-eastus-001 | Central network hub |
| Azure Firewall | AZFW_VNet | Centralized egress filtering |
| Firewall Policy | firewall-policy | DNS/HTTPS outbound rules |
| Public IP | fw-public-ip | Firewall egress IP |

### Spoke (spoke1-rg)

| Resource | Name | Purpose |
|----------|------|---------|
| Virtual Network | spoke1-vnet-eastus-001 | Workload network |
| Application Gateway | appgw-spoke1-eastus-001 | Ingress + WAF v2 |
| App Service | app-spoke1-eastus-001 | Linux .NET 8.0 web app |
| SQL Server | sql-spoke1-eastus-001 | Azure SQL with private endpoint |
| SQL Database | sqldb-spoke1-eastus-001 | Application database |
| Key Vault | kv-spoke1-eastus-001 | Secrets management |
| Log Analytics | law-spoke1-eastus-001 | Centralized logging |
| NSGs | Per subnet | Network-level access control |

### Networking

| Component | Detail |
|-----------|--------|
| VNet Peering | Bidirectional with allow gateway transit |
| Private Endpoint | SQL Server via Private Link |
| VNet Integration | App Service integrated into app subnet |
| Subnets | AppGatewaySubnet, App Subnet, PE Subnet, AzureFirewallSubnet |

## Traffic Flow

**Inbound:** Internet → Application Gateway (WAF v2) → App Service → SQL Private Endpoint → Azure SQL Database

**Outbound:** App Service → VNet Peering → Azure Firewall → Internet

## Security Controls

- **WAF v2** on Application Gateway for OWASP protection
- **Azure Firewall** filtering all egress to ports 53/443 only
- **Private Endpoints** for SQL — no public database access
- **NSGs** on every spoke subnet
- **TLS 1.2** minimum on SQL Server
- **Public access disabled** on SQL Server
- **Key Vault** for secrets storage
- **Diagnostic settings** shipping App Gateway logs to Log Analytics

## Project Structure

    azure-secure-landing-zone/
    ├── environments/
    │   └── dev/
    │       ├── main.tf
    │       ├── variables.tf
    │       ├── terraform.tfvars
    │       └── providers.tf
    ├── modules/
    │   ├── networking/
    │   │   ├── main.tf
    │   │   ├── variables.tf
    │   │   └── outputs.tf
    │   ├── firewall/
    │   │   ├── main.tf
    │   │   ├── variables.tf
    │   │   └── outputs.tf
    │   ├── appgateway/
    │   │   ├── main.tf
    │   │   ├── variables.tf
    │   │   └── outputs.tf
    │   ├── appservice/
    │   │   ├── main.tf
    │   │   ├── variables.tf
    │   │   └── outputs.tf
    │   ├── sql/
    │   │   ├── main.tf
    │   │   ├── variables.tf
    │   │   └── outputs.tf
    │   ├── keyvault/
    │   │   ├── main.tf
    │   │   ├── variables.tf
    │   │   └── outputs.tf
    │   └── loganalytics/
    │       ├── main.tf
    │       ├── variables.tf
    │       └── outputs.tf
    └── README.md

## Prerequisites

- Azure subscription
- Terraform >= 1.0
- Azure CLI authenticated (`az login`)

## Deployment

    cd environments/dev
    terraform init
    terraform plan
    terraform apply

## Variables

| Variable | Description |
|----------|-------------|
| `sql_admin_login` | SQL Server admin username |
| `sql_admin_password` | SQL Server admin password (sensitive) |

## Future Enhancements

- Add Azure Bastion for secure VM access
- Implement Azure Policy assignments
- Add additional spoke VNets
- CI/CD pipeline with GitHub Actions
- Remote state backend with Azure Storage
- Azure Monitor alerts and dashboards

## Built With

- **Terraform** — Infrastructure as Code
- **Azure Provider** — AzureRM
- **Microsoft Cloud Adoption Framework** — Architecture guidance

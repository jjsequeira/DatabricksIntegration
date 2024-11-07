# Databricks Integration with Entra ID

## Overview

This document outlines the process for integrating **Databricks** with **Entra ID** (formerly **Azure Active Directory**) for user provisioning. This integration leverages **Personal Access Tokens** (PAT) for authentication, utilizes **SCIM** (System for Cross-domain Identity Management) for user management, and allows for scheduling automated or manual script execution to add users from specified **Entra ID groups** into Databricks.

## Prerequisites

1. **Databricks Workspace Access**: You must have administrative access to the Databricks workspace in order to generate Personal Access Tokens (PAT).
2. **Entra ID (Azure AD)**: Ensure that the required Azure AD group(s) exist and are populated with the necessary users.
3. **Key Vault**: The Databricks access token must be stored in an **Azure Key Vault**, and the identity running the script must have access to this secret.

---

## Step 1: Obtain the Databricks Personal Access Token

### 1.1 Generate Personal Access Token (PAT)

1. **Log in to Databricks** at [https://accounts.azuredatabricks.net](https://accounts.azuredatabricks.net).
2. Navigate to **User Settings** > **Access Tokens**.
3. Click **Generate New Token**.
4. Copy the generated token. Keep it secure.

### 1.2 Store the Token in Azure Key Vault

1. Place the token in an **Azure Key Vault** secret.
2. **Grant access** to the secret for the identity used by the script (e.g., `identity XXXXXX`).

---

## Step 2: Configure the Script for Additional Databricks Instances

To configure the integration for a new Databricks instance, follow these steps:

### 2.1 Copy an Existing Script

1. Copy an existing Databricks integration script as a template.
2. Paste it below the last entry in the `SCIM AD Groups` configuration file.

### 2.2 Update the Parameters

Modify the script to point to the new Databricks instance and configure the relevant parameters. Specifically, update the following variables:

```powershell
databricksInstance: "https://adb-6234138917436195.15.azuredatabricks.net"  # Databricks Workspace URL
$accessGroups = "Databricks-Group-Test"  # Azure AD Group name
$scimToken = "keyvault-secret-URL"      # URL to the Key Vault secret containing the Databricks PAT

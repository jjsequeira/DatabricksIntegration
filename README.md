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

databricksInstance: "https://adb-6234138917436195.15.azuredatabricks.net"  # Databricks Workspace URL
$accessGroups = "Databricks-Group-Test"  # Azure AD Group name
$scimToken = "keyvault-secret-URL"      # URL to the Key Vault secret containing the Databricks PAT

#### Parameters
databricksInstance: Set this to the URL of the Databricks workspace (e.g., "https://adb-6234138917436195.15.azuredatabricks.net").
$accessGroups: The Azure AD group whose members you want to add to Databricks.
$scimToken: The URL pointing to the Key Vault secret that contains the generated Personal Access Token.

---

## Step 3: Script Execution
The script is set up to run automatically or can be manually triggered as needed.

### 3.1 Automatic Execution
The script can be scheduled to run XX times per day.
You can adjust the schedule based on your organization's requirements.
### 3.2 Manual Trigger
The script can also be manually triggered whenever required to add users from the specified Azure AD group to Databricks.
**Important Information**
Script Scheduling and Manual Trigger:

The script is set up to run XX times per day by default. This schedule can be adjusted to meet your organization's needs.
Alternatively, the script can be manually triggered at any time, allowing you to add users based on the AD group(s) without waiting for the scheduled execution.

---

This process only adds users to the Databricks workspace based on their membership in the provided Azure AD group(s).
This is not a synchronization process, meaning that users who are removed from the Azure AD group will not be automatically removed from Databricks. Any cleanup or removal of users from Databricks must be done manually.

---

## Conclusion

This integration process enables efficient access management via Azure AD groups, streamlining the addition of new users to Databricks. By automating the user provisioning process, organizations can achieve:

**Simplified User Management:** Automatically adding users based on their membership in AD groups reduces manual intervention, ensuring that the right people have access at all times.
**Improved Structure:** Managing access through AD groups allows for a more organized and scalable approach to user access control, particularly as teams grow.
**Centralized Control:** By relying on Azure AD for group management, you maintain a centralized system for user access control, making it easier to track and manage users across multiple systems.

For additional assistance or questions, please refer to Cloud Horizontal team.

---

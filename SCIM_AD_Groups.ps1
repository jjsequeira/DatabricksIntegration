<#
# Service Principal credentials
$tenantId = "f2506bb5-e756-4b9e-a116-0bc7a9c6bca1"
$clientId = "f298173a-20ee-4b2d-a441-952f7c71b3a5"
$clientSecret = "exH8Q~gPnxuHUa4T4RZ6bY5y3B2u3y6tQXExBa.o"

# Convert client secret to SecureString
$secureClientSecret = ConvertTo-SecureString -String $clientSecret -AsPlainText -Force

# Use the Service Principal to authenticate to Azure AD
$creds = New-Object System.Management.Automation.PSCredential ($clientId, $secureClientSecret)
Connect-AzureAD -TenantId $tenantId -Credential $creds 
##Connect-AzureAD -TenantId $tenantId -ApplicationId $clientId
#>

#Connect-AzureAD


#-----------------------------------------------------------------------------------------------------
#                                     Databricks 1 | App: Example
#-----------------------------------------------------------------------------------------------------
# Variables
$databricksInstance = "https://adb-6234138917436195.15.azuredatabricks.net"
$accessGroups = "Databricks-Group-Test"
$scimToken = "dapi0198d54a74558032a6eb428c276287d6-3"



#------------------------------------ DO NOT CHANGE FROM HERE ----------------------------------------
# Headers
$headers = @{
    Authorization = "Bearer $scimToken"
    "Content-Type" = "application/json"
    Accept = "application/json"
}

# Loop through each group and retrieve users
foreach ($group in $accessGroups) {

$groupname = Get-AzureADGroup -Filter "DisplayName eq '$group'"

$users = Get-AzureADGroupMember -ObjectId $groupname.ObjectId

# Loop through each user and assign variables
foreach ($user in $users) {
    # Create variables for SCIM
    $userDisplayName = $user.DisplayName
    $userEmail = $user.UserPrincipalName
    $userId = $user.ObjectId  # Azure AD User Object ID
    $userGivenName = $user.GivenName
    $userSurname = $user.Surname

    # Prepare the SCIM payload (this will depend on your SCIM schema)
    $userData = @{
        "schemas" = @("urn:ietf:params:scim:schemas:core:2.0:User")
        "userName" = $userEmail
        "name" = @{
            "givenName" = $userGivenName
            "familyName" = $userSurname
        }
        "emails" = @(@{"value" = $userEmail; "primary" = $true})
        "displayName" = $userEmail
        "active" = "true"
            } | ConvertTo-Json

    # Display the user info (for testing)
    Write-Host "Creating user for $userDisplayName ($userEmail)"

    # API URL
$userApiUrl = "$databricksInstance/api/2.0/preview/scim/v2/Users"

    # Create user via POST request
try {
    $response = Invoke-RestMethod -Method Post -Uri $userApiUrl -Headers $headers -Body $userData
    Write-Host "User created successfully"
}
catch {
    Write-Host "Failed to create user. Error:"
    Write-Host $_.Exception.Message
    # Optional: Display more details if available
    if ($_.Exception.Response) {
        $errorResponse = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorResponse)
        $errorContent = $reader.ReadToEnd()
        Write-Host "Error response: $errorContent"} 
                                                     }
  }
}
#----------------------------------------- End of the script -----------------------------------------
#-----------------------------------------------------------------------------------------------------



#-----------------------------------------------------------------------------------------------------
#                                    Databricks 2 | App: Example
#-----------------------------------------------------------------------------------------------------


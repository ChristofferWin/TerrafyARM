# TerrafyARM - The worlds first Azure-ARM to Terraform transformation system
This marks the very first release of the product - '0.1.0-alpha' ![TerrafyARM mascot](https://github.com/ChristofferWin/TerrafyARM/blob/main/docs/TerrafyARM%20mascot%20small.png)


## Disclaimer
This is an alpha release so expect bugs. Please report any issues over at => https://github.com/ChristofferWin/TerrafyARM/issues

This software is designed to take ARM templates that describes resources that are under the umbrella: The "AzureRM" Terraform provider => https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

This means that, at this moment, 'TerrafyARM' Is able to transform ARM templates from resources:

1. Any resource that resides inside of an Azure subscription
2. Management groups
3. Some elements of Azure Entra ID

In a nutshell, the same as all resources defined under the Terraform documentation above. You MIGHT find resource types not being transformed correctly; this can always be raised as an issue. As the software progresses, fewer and fewer items will be "missed" from the ARM templates.

You can feed the application any number of ARM templates from any number of subscriptions and in any order.

<b>NOTE:

ARM templates fed to 'TerrafyARM' MUST adhere to a certain standard and using directly exported templates will NOT work. Exported templates using "Export Azure" will create ARM templates structued in a way that the application simply does not understand.</b>

Instead - Use a tool like az cli to retrieve ARM templates:

### PowerShell and CLI ARM template extracting example
The code below WILL work on Linux and MacOS if PowerShell Core is installed.
PowerShell Core installation => https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.4

````ps1
#Have az CLI installed => https://learn.microsoft.com/en-us/cli/azure/install-azure-cli
#Make sure to be logged in:
az login
$folderPath = "./" #Path to where you want the ARM templates
mkdir $folderPath
$subscriptions = az account subscription list | ConvertFrom-Json | % {$_.id.Split("/")[-1]}
$resourceIDs = @()

foreach($subscription_id in $subscriptions) { #PULLING EVERYTHING CONTEXT CAN SEE
  Write-Output "Retrieving resources from sub $subscription_id"
  az account set --subscription $subscription_id
  $resourceIDs += az resource list | ConvertFrom-Json | % {$_.id}
}

foreach($resource in $resourceIDs) {
    az account set --subscription $resource.Split("/")[2]
    Write-Output "Writing resource $resource to folder $folderPath"
    #You might want to replace more than just spaces to "_" As some Azure resources can contain symbols like %$# etc.
    az resource show --id $resource | Out-File "$folderPath/$($resource.Split("/")[-1].Replace(" ", "_")).json"
}

#This might take a while, depending on the amount of resources / subscriptions
````

## Getting started
Download 'TerrafyARM' Either from source (<a href="">releases</a>) or one of the following package managers:

1. [Brew (MacOS)](#install-via-brew)
2. [Chocolatey (Windows)](#install-via-chocolatey)
3. [Snapcraft (Linux)](#install-via-snapcraft)

Note: Using a package manager is ALWAYS recommended

### Install via Brew
````bash
#Add the tap as the application is not part of brew core
brew tap ChristofferWin/terrafyarm
#Let brew do its magic
brew install terrafyarm
#Version output and your ready to go
#OUTPUT from 'terrafyarm -version' 
The current version of the 'TerrafyArm' Decompiler is '0.1.0'
For information about versions, please check the official Github release page at:
https://github.com/ChristofferWin/TerrafyARM/releases
````

### Install via Chocolatey
````ps1
#Simply run the install command
choco install terrafyarm
#Remember, since Windows is IN-casesensitive, we can call the executeable like
TerrafyARM -help
#OUTPUT
The current version of the 'TerrafyArm' Decompiler is '0.1.0'
For information about versions, please check the official Github release page at:
https://github.com/ChristofferWin/TerrafyARM/releases
````

### Install via Snapcraft
````bash
#Simply run the install command
sudo snap install terrafyarm
#Check whether installation is OK and application is in the PATH variable
TerrafyARM -help
#OUTPUT
The current version of the 'TerrafyArm' Decompiler is '0.1.0'
For information about versions, please check the official Github release page at:
https://github.com/ChristofferWin/TerrafyARM/releases
````


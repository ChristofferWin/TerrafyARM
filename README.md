# TerrafyARM - The worlds first Azure-ARM to Terraform transformation system
The TerrafyARM mascot says HI and welcome to the worlds very first ARM to Terraform decompiler / compiler!
![TerrafyARM Logo](https://github.com/ChristofferWin/TerrafyARM/raw/main/logo.png "TerrafyARM - Decompiling ARM Templates")


## Sections
1. [Disclaimer](#disclaimer)
2. [PowerShell and CLI ARM Template Extracting Example](#powershell-and-cli-arm-template-extracting-example)
3. [Getting Started](#getting-started)
    - [Install via Brew](#install-via-brew)
    - [Install via Chocolatey](#install-via-chocolatey)
    - [Install via Snapcraft](#install-via-snapcraft)
4. [Examples](#examples)


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

NOTE 1: The actual executable program name is *terrafyarm* on Linux and MacOS, as these operating systems are case-sensitive

NOTE 2: Using a package manager is ALWAYS recommended

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

## Examples
Lets explorer some of the features that TerrafyARM provides:

1. [1 ARM template file containing resources from 1 subscription](#install-via-brew)
2. [A folder of ARM template files containing resources from 1 subscription](#install-via-chocolatey)
3. [A folder of ARM template files containing resources from MULTIPLE subscriptions](#install-via-snapcraft)

NOTE: Make sure that the ARM templates are in a valid format for TerrafyARM - Check [PowerShell and CLI ARM template extracting example](#powershell-and-cli-arm-template-extracting-example) 

### 1 ARM file - 1 Azure Subscription (Simple)
When Azure resources have sub-components, TerrafyARM must isolate them during runtime, determining whether the resource can be defined separately from the main resource or not in Terraform.

E.g., take an Azure Virtual Network – it can contain subnets, peerings, and more. Subnets, in terms of Terraform, can be defined as blocks within the Virtual Network, but something like Peerings can’t. This results in TerrafyARM building a Virtual Network Terraform resource, where the subnet is directly defined within it, and any peering will be created as a separate resource definition.
````ps1
#TerrafyARM allows that you only provide an output folder path location as either a relative or full path - It does not care if you use '/' or '\'

#By ommiting the 'file-path' flag, the ARM template MUST reside at the CURRENT location of the environment, e.g. 'cd <path to where I run the application from>'

<#Lets say we have an ARM template consiting of:
1 Azure Resource Group
1 Azure Virtual Network with 1 subnet and 1 peering
1 Azure VM
#>
terrafyarm -output-file-path ./my-terraform-templates #terrafyarm will create the folder if it does not exist
# EXAMPLE OUTPUT FROM APPLICATION
ARM source file(s) location: ./
ARM files analyzed: 1
Terraform file(s) location: ./my-terraform-templates
Terraform files created: 5
Terraform resources defined: 4

#If you then take an ls of newly created folder './my-terraform-templates' we will see:
cd ./my-terraform-templates
ls
#OUTPUT FROM LS
linux_virtual_machine.tf
providers.tf #This will only contain the 'default' AzureRM context, because we only ran resources defined in 1 Azure Subscription
resource_group.tf
virtual_network_peering.tf
virtual_network.tf

#The Terraform code is ready to be run, make sure write access to the subscription via az cli
#Terraform commands
terraform init
terraform plan
terraform apply
````

### Folder of ARM templates with resources defined for 1 Azure Subscription
Please see example [1 ARM file - 1 Azure Subscription (Simple)](#powershell-and-cli-arm-template-extracting-example) first as the behaviour is exactly the same, only now we define flag 'file-path' to tell TerrafyARM where the folder of ARM templates are located.

The final Terraform compiled code will be exactly the same, so separate your resources HOWEVER you like.

````ps1
<#As from example 1, we use the same resources, but now they are seperated into the following ARM files:

1. virtual_network.json //The name can be anyting we want, but MUST end with .json
2. resource_group.json
3. linux_virtual_machine.json 
#>

#Run TerrafyARM on the given folder
terrafyarm -file-path ./my-arm-templates -output-file-path ./my-terraform-templates
# EXAMPLE OUTPUT FROM APPLICATION
ARM source file(s) location: .\my-arm-templates\
ARM files analyzed: 3 #Now we analyze 3 files
Terraform file(s) location: .\my-terraform-templates
Terraform files created: 5
Terraform resources defined: 4
````

### Multiple ARM templates from multiple Azure Subscriptions
This example showcases the scenario of "scraping" entire environments out of Azure and then controlling the Terraform provider configuration for all the resulting compiled Terraform resource definitions. To understand what 'Terraform Providers' means, please read the HashiCorp documentation: [Terraform Provider docs](https://developer.hashicorp.com/terraform/language/providers)

If in doubt about how to "scrape" your Azure resources, check out [1 ARM file - 1 Azure Subscription (Simple)](#powershell-and-cli-arm-template-extracting-example) first before continuing

NOTE: Using custom Terraform providers is NOT required, as TerrafyARM can automatically handle it. The consequence is provider names suffixed with the first segment of an Azure Subscription ID and the name, e.g., alias = auto_provider_00000000

````ps1
<#The number of resources, ARM files and different subscriptions are not important for this example

Instead, just focuse on the following facts as an example:
1. We have subscription with id "00000000-0000-0000-0000-000000000000"
2. We have subscription with id "11111111-1111-1111-1111-111111111111"
3. Both subscriptions have many different resources, but we want to make sure its clear in the Terraform code, that the resources using the provider has specific human like names
#>

#Use of flag '-custom-terraform-provider-names' To control the names of the 2 subscription_id's above

#Use the TerrafyARM -help flag to see the naming requirements for custom Terraform providers

terrafyarm -file-path ./my-arm-templates -output-file-path ./my-terraform-templates  -custom-terraform-provider-names "00000000-0000-0000-0000-000000000000=my0provider,11111111-1111-1111-1111-111111111111=my1provider"

# FROM provider.tf AFTER these custom settings example
provider "azurerm" {
  features {}
  alias           = "my0provider"
  subscription_id = "00000000-0000-0000-0000-000000000000"
}


provider "azurerm" {
  features {}
  alias           = "my1provider"
  subscription_id = "11111111-1111-1111-1111-111111111111"
}

#The resources with set subscription_id's WILL have your new custom providers
````
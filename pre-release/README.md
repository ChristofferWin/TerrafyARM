# TerrafyARM  

**Transform ARM templates into valid Terraform code.**  

TerrafyARM is a powerful tool designed to simplify your migration from Azure Resource Manager (ARM) templates to Terraform configurations. Whether you’re working with nested resources, complex configurations, or separated files, TerrafyARM makes it easier to adopt Infrastructure-as-Code (IaC) practices with Terraform.  

---

## Features  

- **ARM-to-Terraform Conversion**: Supports most ARM templates, regardless of size or structure.  
- **Flexible Input**: Process multiple templates in any order or configuration.  
- **Streamlined Terraform Output**: Generates valid Terraform code that’s ready to use.  
- **Open Source**: Built by the community, for the community.  

---

## Installation  

### Prerequisites  
1. Google Chrome is an essential part of 'TerrafyARM' And must be installed on the system before running the application
2. For the final terraform code to look pretty its recommended to have 'Terraform' installed ahead of time but its not required

### Getting Started
(THIS IS ONLY BECAUSE ITS THE PRELEASE, IT WILL BE WORDED DIFFERENTLY IN THE OFFICIAL RELEASE THURSDAY)

(The tests are more cool, the more different subscriptions you retrieve ARM templates from)

1. Retrieve ARM templates to run on the application.
    1. A few is provided besides the readme, but I encorouge you to use any resource types in Azure Subscriptions you have access to (Remember, nothing is saved anywhere else than on your local machine)
2. There are 3 folders with different OS-executeables - If your in doubt, your CPU is running the AMD64 architecture
3. Retrieve the executeable - You can even make it part of your path, this way you can run the application from anywhere on the machine
    1. Place the executeable whereever you see fit, for Windows I recommend <\x86/ TerrafyArm/TerrafyARM.exe\> 

### Running the application
```ps1
#All examples will use a POWERSHELL terminal, but ANY SHELL is OK
#If you do not have the application in $env:PATH 
#you need to prefix the application call with <path to application/TerrafyARM.exe -ARGUMENTS>
#Please run TerrafyARM -help FIRST
TerrafyARM -help
TerrafyARM -file-path ./My-Super-Cool-ArmTemplates -output-file-path ./TerrafyArm-Will-Create-this-for-me -verbose
```

### After running the first time
```ps1
<#
After running the first time, notice how the application created a folder called 'terrafyarm' Where inside of said folder lays the cache of the application

IF you ever add NEW resource types the cache will NOT automcatically update as of version 0.1.0 which means you need to run:
#>

TerrafyARM TerrafyARM -file-path ./My-Super-Cool-ArmTemplates -output-file-path ./TerrafyArm-Will-Create-this-for-me -verbose -clear-cache //First we just add the argument and run

#We then run the first command again but without clear
TerrafyARM -file-path ./My-Super-Cool-ArmTemplates -output-file-path ./TerrafyArm-Will-Create-this-for-me -verbose //Cache is now clear and can gather ALL resource types

<#
Its VERY important to state that its NOT necessary to clear the cache EVERY 2nd run, its simply to state - e.g. You have cached Azure SQL and Azure Monitor and now add a new type to the mix, then we need to clear-cache first, then rerun as above.
#>

#Caching will get better as we move forward but it will have to do for now
```

### For the Daring...
If you have the time, please try any of the features that the application can provide in this state and even try to break it, hell I broke it once making this readme (Will be fixed before Thursday :D)

USE the -help COMMAND if in doubt....
# POC Azure Data Factory Resource Provision

![Terraform](https://github.com/destinygit/Terraform/blob/main/og-image.png)

## Installations Requirements


### Azure CLI
> Install az CLI

Follow these steps [AZ CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli)

### Terraform CLI
> Install terraform CLI

Link [Terraform CLI](https://www.terraform.io/downloads)

## Check if az and terraform are installed

> Open your command line and type for `Windows`:
```
terraform -version
az -version
```



## TroubleShoot Terraform or Az CLI Error on cmd AFTER installation :space_invader:
> Solution:

#### Add the _.exe terraform file path_ to your `Environment Variables path` 
#### Add the *.exe az file path* to your `Environment Variables path` 
> **then _RESTART_ your PC** :face_exhaling:

# Running Your CODE (_vscode_)

1. `az login`
    - If there are many _Subscriptions_ in Tenant or didnt specify *Subscription_ID* under the `provider` block
        *`az account set --subscription "subcription id or Name"`

2. Terraform Commands to RUN your CODE

```
Main commands:
  init          Prepare your working directory for other commands
  validate      Check whether the configuration is valid
  plan          Show changes required by the current configuration
  apply         Create or update infrastructure
  destroy       Destroy previously-created infrastructure

```


### EDITOR : Vhutshilo-R :woman_technologist:

> For further queries:
>_Ping Me_: [Email Address](vee@tangentsolutions.co.za) 



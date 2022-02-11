# POC Azure Data Factory Resource Provision

![Terraform](https://www.google.com/search?q=terraform+logo&rlz=1C1FKPE_enZA982ZA982&sxsrf=APq-WBuykj-F8CKdeBaQ0Tb57-OPtCK2rA:1644594818117&source=lnms&tbm=isch&sa=X&ved=2ahUKEwjQpruPgfj1AhXUoVwKHYwbCgMQ_AUoAXoECAEQAw&biw=1366&bih=560&dpr=1#imgrc=hpibvN2PDf_MVM)

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
_Ping Me_: [Email Address](vee@tangentsolutions.co.za) 



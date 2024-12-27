## Starter Action Workflows to deploy to Azure

[GitHub Actions for Azure](https://github.com/Azure/actions) help you easily create workflows to build, test, package, release and deploy to Azure, following a push or pull request.

You use Azure starter templates present in this repo to easily create GitHub CI/CD workflows targeting Azure, to deploy your apps created with popular languages and frameworks such as .NET, Node.js, Java, PHP, Ruby or Python, in containers or running on any operating system.

# Action Samples for deploying using Terraform

With Terraform workflows, you can automate your terraform templates to deploy to Azure.

Terraform templates use Azure Resource Manager to deploy resources to Azure. More details on Terraform Provider for Azure can be found [here](https://www.terraform.io/docs/providers/azurerm/index.html).

## Configure Azure credentials

To fetch the credentials required to authenticate with Azure, run the following command:

```sh
az ad sp create-for-rbac --name "myApp" --role contributor \
                            --scopes /subscriptions/{subscription-id}/resourceGroups/{resource-group} \
                            --sdk-auth

  # Replace {subscription-id}, {resource-group} with the subscription, resource group details

  # The command should output a JSON object similar to the example below

  {
    "clientId": "<GUID>",
    "clientSecret": "<GUID>",
    "subscriptionId": "<GUID>",
    "tenantId": "<GUID>",
    (...)
  }
```

Add the JSON output as secrets TF_VAR_agent_client_id, TF_VAR_agent_client_secret, TF_VAR_subscription_id, TF_VAR_tenant_id in the GitHub repository. For steps to create and storing secrets, please check [here](https://docs.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets)

The terraform deployment actions expects the terraform templates to be stored in the root directory. If the terraform templates are stored in a different directory, update the path to terraform actions. More information on terraform actions can be found [here](https://www.terraform.io/docs/github-actions/setup-terraform.html)

For additional help on how use Azure actions, please refer [here](https://github.com/Azure/Actions)

## Terraform Sample Templates

For additional terraform sample templates for Azure deployment, please refer to these [quick-start templates](https://github.com/Azure/terraform/tree/master/quickstart)
```TF_LOG=DEBUG DATABRICKS_DEBUG_TRUNCATE_BYTES=250000 terraform apply -no-color 2>&1 |tee tf-debug.log```

## GitHub Action Workflows

For more samples to get started with GitHub Action workflows to deploy to Azure refer [here](https://github.com/Azure/actions-workflow-samples)

## Guidelines to select/author a new sample workflow

**Folder Structure:**
These workflow samples to automate your deployment workflows targeting various Azure services are organized under folders of same names. For example: `/AppService/asp.net-core-webapp-on-azure.yml`

- [**/AppService** ](https://github.com/Azure/actions-workflow-samples/tree/master/AppService) Samples to configure and deploy web applications that scale with your business, to [Azure App Service](https://azure.microsoft.com/en-us/services/app-service/web/)

- [**/AzureCLI**](https://github.com/Azure/actions-workflow-samples/tree/master/AzureCLI) Samples to run Azure CLI scripts to provision and manage Azure resources from a GitHub Action workflow

- [**/ARM**](https://github.com/Azure/actions-workflow-samples/tree/master/ARM) Samples to deploy [Azure Resource Manager templates](https://docs.microsoft.com/bs-latn-ba/azure/azure-resource-manager/templates/)

- [**/AzurePipelines**](https://github.com/Azure/actions-workflow-samples/tree/master/AzurePipelines) Samples to trigger a CD run in Azure Pipelines from a GitHub Action workflow

- [**/Database**](https://github.com/Azure/actions-workflow-samples/tree/master/Database) Samples to deploy to a database on Azure, [Azure SQl database](https://azure.microsoft.com/en-us/services/sql-database/) or [Azure MySQL database](https://azure.microsoft.com/en-us/services/mysql/)

- [**/FunctionApp**](https://github.com/Azure/actions-workflow-samples/tree/master/FunctionApp) Samples to build and deploy serverless apps to [Azure Functions](https://azure.microsoft.com/en-us/services/functions/)

- [**/Kubernetes**](https://github.com/Azure/actions-workflow-samples/tree/master/Kubernetes) Samples to deploy to any Kubernetes cluster on-premise or any cloud including [Azure Kubernetes service](https://azure.microsoft.com/en-us/services/kubernetes-service/)

- [**/MachineLearning**](https://github.com/Azure/actions-workflow-samples/tree/master/MachineLearning) Samples to build and deploy machine learning models using [Azure Machine Learning](https://docs.microsoft.com/en-us/azure/machine-learning/)

- [**/Terraform**](https://github.com/Azure/actions-workflow-samples/tree/master/Terraform) Samples to deploy infrastructure to an Azure subscription using [Terraform Azure Provider](https://www.terraform.io/docs/providers/azurerm/index.html)

- [**/AzurePolicy**](https://github.com/Azure/actions-workflow-samples/tree/master/AzurePolicy) Samples to trigger on-demand Azure Policy compliance scans from a GitHub Action workflow

- [**/End-to-End/Serverless**](/End-to-End/Serverless-web-application) Sample to deploy and manage the lifecycle of a [serverless web application](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/serverless/web-app). The application serves static content from Azure Blob Storage, and implements an API using Azure Functions which is exposed through API Management. The API reads data from Cosmos DB and returns the results to the web app.

**Naming Notation:**
* `os-ecosystem-ServiceName-on-azure`: example, linux-container-functionapp-on-azure.yml
* OS in the name is optional if the action workflow sample is OS agnostic and doesnt significantly change between OS (Linux/Windows) 
* Ecosystem can be a language (.NET, Nodejs, java, Python, Ruby etc.) or Docker/Container Or Database flavours like SQL/MySQL etc.

**Workflow structure**
* Include 'name' for every workflow to indicate the purpose of the workflow
* Ensure that starter workflows run on: push by default.  
* For all secrets to be defined in the workflow, use UPPER_CASE with underscore delimiters instead of snake_case or camelCase.
* Include a commented **Configuration section** which includes hyperlinks to documentation for the Actions used and other pre-reqs.
* Define environment variables as part of configuration.  We think this will help provide visibility into the things that need to be configured as part of te workflow.
* Ensure all Azure actions referenced in the workflow are pointing to a released version of the action and not from the master. For list of all released GitHub actions for Azure, please refer to https://github.com/Azure/actions

## Contributing

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

### Top contributors:

1. Deploy Databricks with VNETinjection using Terraform via Github actions -> https://github.com/databricks/terraform-databricks-examples/tree/main/examples/adb-vnet-injection
Azure Virtual Network (VNet) injection is necessary for deploying Azure Databricks notebooks through Terraform and Git Actions
2. Configure authentication correctly -> https://registry.terraform.io/providers/databricks/databricks/latest/docs#authenticating-with-azure-service-principal
3. https://registry.terraform.io/providers/databricks/databricks/latest/docs/guides/troubleshooting#data-resources-and-authentication-is-not-configured-errors
4. Get Microsoft Entra ID tokens for service principals -> https://learn.microsoft.com/en-us/azure/databricks/dev-tools/service-prin-aad-token#--get-an-azure-active-directory-access-token
5. Azure Databricks & Terraform for dummies -> https://medium.com/@robbiedouglas/getting-started-with-azure-databricks-using-terraform-bf993cccf758
6. https://medium.com/databricks-platform-sme/step-by-step-setting-up-a-ci-cd-pipeline-with-asset-bundle-for-dlt-using-private-agents-on-azure-92e6e0f5bea1
7. https://registry.terraform.io/providers/databricks/databricks/latest/docs/guides/troubleshooting#data-resources-and-authentication-is-not-configured-errors

## License
Distributed under the Unlicense License. See `https://interoperable-europe.ec.europa.eu/licence/unlicense` for more information.

ContosoUniversity
=================

First we will deploy this app to App Service

## How to deploy:
For easy deployment we created a [Bicep](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview?tabs=bicep) that will deploy all resources we want for us.

- Just Open the Folder **BicepDeployment** in [VS Code](https://code.visualstudio.com/)
- Right Click on **main.bicep** Then Choose **Deploy Bicep File**
![Untitled](https://user-images.githubusercontent.com/17393156/181486255-212dedd3-1658-4cea-a285-aaa135844f50.png)

### Then We Will Setup CI/CD Pipeline easily
- After Deployment is successful
![image](https://user-images.githubusercontent.com/17393156/181486505-f2f23958-28c9-49be-a2b2-c98291810add.png)
- Go to App services and select the app we just created with the name **Contoso University**
- Then Go to **Deployment Center** under **Deployment**
![Untitled1](https://user-images.githubusercontent.com/17393156/181487087-bb114bed-fad1-4f4d-ad23-cf78679f3aac.png)
- Then we will configure CI/CD
- Choose the source for code base
- And choose the runtime
- Then save.

P.S This will create yaml file under workflow directory
And Thats it.

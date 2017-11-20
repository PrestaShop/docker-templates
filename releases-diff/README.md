# Docker compose template for several PrestaShop releases diff

In case you want to compare two releases of PrestaShop, you can use this docker-compose template.

## Pre-requesites:
* Add your PrestaShop release archive in the test folder, with the exact name `release.zip`.
* Some parameters can be changed in the `docker-compose.yml` file, you can set the PrestaShop version you want to use as reference.
* To make your blackfire account working with this stack, you MUST declare 4 environment variables, as explained in the official documentation: https://blackfire.io/docs/integrations/docker
* When you are ready, launch the stack with the following command:

```
docker-compose up
```

## Runing containers:

Two websites will be deployed:
The reference release: http://localhost:8001
The release to be tested as comparison: http://localhost:8002

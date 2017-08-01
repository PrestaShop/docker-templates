# PrestaShop Dump

## What does this folder contain?

You can find a docker template for a standalone PrestaShop container, running Apache + MySQL in it.
When started, it executes the files available in `prestashop-dataset`, or the folder specified in the docker-compose.yml file.

## How to run this shop

First, unzip the file `prestashop-dataset.zip` which contains all the shop files, but has too many small files to commited as a simple folder.

If you keep this environment, run the following command:

```
docker-compose up
```

Your can then be reached at the address http://localhost/prestashop-dataset (default conf).

In case of blank page, check the logs displayed on your terminal. The common fixes are:
* Giving write permission to all on the PrestaShop files
* Dropping the app/cache/* folders in order to remove old config

Enjoy!

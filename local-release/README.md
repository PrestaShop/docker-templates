# PrestaShop Dump

## What does this folder contain?

You can find a docker template for a standalone PrestaShop container, running Apache + MySQL in it.
When started, it runs a local folder in your filesystem.

## How to run this shop

* Open the docker-compose.yml file, and replace <PATH TO PRESTASHOP> with the release you want to test.
* Run the following command:

```
docker-compose up
```

A LAMP stack will be downloaded and ran.
Once ready, your shop can be reached at the address http://localhost:8081 (default conf).

In case of blank page, check the logs displayed on your terminal. The common fixes are:
* Giving write permission to all on the PrestaShop files
* Dropping the app/cache/* folders in order to remove old config

Enjoy!

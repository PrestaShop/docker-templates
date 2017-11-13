# PrestaShop Dump

## What does this folder contain?

You can find a docker template for a standalone PrestaShop container, running Apache + MySQL in it.
When started, it executes the latest release of PrestaShop 1.7 available on Docker, or the folder specified in the docker-compose.yml file (if modified).

## How to run this shop

Run the following command:

```
docker-compose up
```

A pre-installed PrestaShop will be downloaded from Docker hub, and the dump available in `bdd.sql` will restored in the MySQL database.
Once ready, your shop can be reached at the address http://localhost:8081 (default conf).

In case of blank page, check the logs displayed on your terminal. The common fixes are:
* Giving write permission to all on the PrestaShop files
* Dropping the app/cache/* folders in order to remove old config

Enjoy!

# Autoupgrade stack

## What does this folder contain?

The `docker-compose.yml` contains a configuration that allows you to run PrestaShop with the upgrade module mounted as a volume.

This stack can be used for development and testing of the module, therefore xDebug will be present.

## How to run this shop

### Pre-requesites

To initialize your environment properly, the upgrade module needs to be present in this directory in the folder `autoupgrade`.

```bash
git clone https://github.com/PrestaShop/autoupgrade.git
# or
ln -s [path/to/your/module]/autoupgrade
```
Additional commands may be needed inside the module folder to have it ready to run (i.e Composer).

### Starting-up

When ready, run the following command:

```bash
docker compose up
```

A release of PrestaShop will be downloaded and installed on startup. xDebug will be installed between the installation of PrestaShop and Apache startup.

Once ready, your shop can be reached at the address http://localhost:8081 (default conf).

xDebug is configured to display full stack-traces and allow debuggers to listen on port 9007.

## Customization options

Default versions for PrestaShop and Mysql are provided in the `.env` file. To customize these values, additional environment files can be created and provided in the start command.

```bash
docker compose --env-file .env --env-file .env.override up
```



## Notes

### Permission on upgrade module

The container may not have write access to the `autoupgrade` directory. This can be reported on the upgrade checklist, where the shop cannot write on the `modules/` folder.

A solution that won't impact the diff of the repository is to change the ownership of this folder and its child elements.

```bash
chown <your_user>:www-data -R autoupgrade
```

### Enabling the shopContent volume 

When uncommenting the volume to get the shop files inside the `shopContents/` directory, note you may need to erase this folder before starting over.
If you keep the folder as-is, you may encounter a message "Shop is already installed" on startup and a non-working shop.

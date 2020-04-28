# docker-templates
Docker &amp; docker-compose templates

Currently including:

* **releases-diff**: A stack to compare PrestaShop releases
* **from-dump**: A standalone PrestaShop dockerized
* **local-release**: To run PrestaShop from a release located on your filesystem
* **nginx-php-fpm**: A full nginx php-fpm stack to work as fast as a bald eagle
* **apache2-php-fpm**: A full apache2 php-fpm stack to be as bold as a jumping cougar

## Introduction

Those docker templates should allow you to fastly work with a dockerized PrestaShop solution.

## Prerequisites

There is not much prerequisite than a running docker with compose version 3.

Aside from that, you should be good to go.

## How to

Pretty simple here as well, as you'll see.

You just go to the directory you're interested in:

```
cd local-release/
```
You then launch the local stack:

```
docker-compose up
```

And you can then launch your favorite browser to http://localhost:8081

## Configuration

If you're not running the apache2 php-fpm stack on your local machine, you may want to update the `PS_DOMAIN` variable in the docker-compose file.

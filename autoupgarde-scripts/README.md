# Utility script to quickly test the autoupgade module

The script allows testing the upgrade between 2 versions of PrestaShop, with the possibility of obtaining a
database dump and comparing it with a dump from a fresh install.

A "recursive" mode is available and allows performing all updates between 2 versions.

The entire process is containerized.

## Prerequisites

- OS: Linux
- Tools: Docker (with compose plugin)

## How it works ?

Configure the [.env](.env) file, and run:

```shell
$ ./upgrade.sh
```

3 directories will be created:

- dumps: contains generated dumps and diffs
- logs: contains installs and upgrades logs
- releases: contains Prestashop releases

The updated store is available at http://localhost:8002/admin (by default) after process

**Email:** demo@prestashop.com
**Password:** Toto123!

## Available versions

- 1.7.0 and its patch versions
- 1.7.1 and its patch versions
- 1.7.2 and its patch versions
- 1.7.3 and its patch versions
- 1.7.4 and its patch versions
- 1.7.5 and its patch versions
- 1.7.6 and its patch versions
- 1.7.7 and its patch versions
- 1.7.8 and its patch versions
- 8.0 and its patch versions
- 8.1 and its patch versions

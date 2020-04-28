Docker compose template with apache2 and php-fpm

Want a nice a fast stack to run your PrestaShop ? We've got you covered !

This stack contains a docker-compose building up:
* Apache2 in front
* PHP-FPM (version 7.2) to run your PrestaShop
* MySQL (version 5.7 by default)

Some parameters can be changed in the `docker-compose.yml` file.

When you are ready, launch the stack with the following command:

```
docker-compose up
```

The website will be available at the address http://localhost:8002/.
You can check everything is running with the following page: http://localhost:8002/phpinfo.php

If everything works well, just add your PHP files in the `www/` folder.

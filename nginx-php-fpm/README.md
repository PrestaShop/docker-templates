# Docker compose template with Nginx

Want a different stack to run your website? You just found it.

This folder contains a docker-compose which deploys several containers:
* Nginx
* PHP-FPM (by default with PHP 7.1)
* MySQL (5.7 by default)

Some parameters can be changed in the `docker-compose.yml` file.

When you are ready, launch the stack with the following command:

```
docker-compose up
```

The website will be available at the address http://localhost:8002/.
You can check everything is running with the following page: http://localhost:8002/phpinfo.php

If everything works well, just add your PHP files in the `www/` folder.


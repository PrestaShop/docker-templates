
ARG phpbuild
FROM php:$phpbuild

MAINTAINER Thomas Nabord <thomas.nabord@prestashop.com>

RUN echo 'deb http://ftp.uk.debian.org/debian jessie-backports main' >> /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install -y libmcrypt-dev \
		libjpeg62-turbo-dev \
                libpcre3-dev \
		libpng12-dev \
		libfreetype6-dev \
		libxml2-dev \
		libicu-dev \
		ffmpeg \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install iconv intl mcrypt opcache pdo pdo_mysql mbstring soap gd zip \
	&& rm -rf /var/lib/apt/lists/*


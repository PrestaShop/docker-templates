#!/bin/bash

apt update && apt install -y git
XDEBUG_VERSION=$(git ls-remote --sort='version:refname' --tags https://github.com/xdebug/xdebug.git | grep -oh "3\.1\.[0-9]" | tail -1)
pecl install xdebug-$XDEBUG_VERSION
echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini;

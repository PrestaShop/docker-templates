FROM quetzacoalt/docker-internal-images:1.7

ENV PS_DOMAIN localhost
ENV DUMP_PHP_FILES prestashop-dataset
ENV DUMP_SQL_FILE prestashop-dataset.sql

# Copy files
COPY $DUMP_PHP_FILES/ /var/www/html/
COPY $DUMP_SQL_FILE /tmp/dump.sql

# Restore SQL dump & update shop URL
RUN service mysql start \
	&& mysqladmin -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD drop $DB_NAME --force 2> /dev/null \
        && mysqladmin -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD create $DB_NAME --force 2> /dev/null \
	&& mysql -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD $DB_NAME < /tmp/dump.sql \
	&& mysql -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD -e "UPDATE \`ps_shop_url\` SET \`domain\`='$PS_DOMAIN', \`domain_ssl\`='$PS_DOMAIN', \`physical_uri\`='/' WHERE \`id_shop_url\`=1;" $DB_NAME \
	&& mysql -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD -e "UPDATE \`ps_configuration\` SET \`value\`='$PS_DOMAIN' WHERE \`name\`='PS_SHOP_DOMAIN';" $DB_NAME \
	&& mysql -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD -e "UPDATE \`ps_configuration\` SET \`value\`='$PS_DOMAIN_SSL' WHERE \`name\`='PS_SHOP_DOMAIN';" $DB_NAME

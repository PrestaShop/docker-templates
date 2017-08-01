FROM quetzacoalt/docker-internal-images:1.7

ENV PS_DOMAIN localhost
ENV DUMP_PHP_FILES prestashop-dataset
ENV DUMP_SQL_FILE prestashop-dataset.sql

# Copy files
COPY $DUMP_PHP_FILES/ /var/www/html/
RUN ln -s /var/www/html/ /var/www/html/$DUMP_PHP_FILES/
COPY $DUMP_SQL_FILE /tmp/dump.sql

# Restore SQL dump
RUN service mysql start \
	&& mysqladmin -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD drop $DB_NAME --force 2> /dev/null \
        && mysqladmin -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD create $DB_NAME --force 2> /dev/null \
	&& mysql -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD $DB_NAME < /tmp/dump.sql

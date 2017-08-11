#!/bin/bash

# Restore SQL dump & update shop URL
service mysql start

FILE="/tmp/imported"
if [ ! -f $FILE ]; then
	mysqladmin -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD drop $DB_NAME --force 2> /dev/null
	mysqladmin -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD create $DB_NAME --force 2> /dev/null

	echo "\n* Importing SQL file ...";
	mysql -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD $DB_NAME < $DUMP_SQL_FILE
	echo "\n* Update shop URL ...";
	mysql -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD -e "UPDATE \`ps_shop_url\` SET \`domain\`='$PS_DOMAIN', \`domain_ssl\`='$PS_DOMAIN', \`physical_uri\`='/' WHERE \`id_shop_url\`=1;" $DB_NAME
	mysql -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD -e "UPDATE \`ps_configuration\` SET \`value\`='$PS_DOMAIN' WHERE \`name\`='PS_SHOP_DOMAIN';" $DB_NAME
	mysql -h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD -e "UPDATE \`ps_configuration\` SET \`value\`='$PS_DOMAIN_SSL' WHERE \`name\`='PS_SHOP_DOMAIN';" $DB_NAME

	touch $FILE
fi
bash /tmp/docker_run.sh

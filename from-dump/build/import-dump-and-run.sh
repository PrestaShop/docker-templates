#!/bin/bash

# Restore SQL dump & update shop URL
service mysql start

MYSQL_CRED="-h $DB_SERVER -P $DB_PORT -u $DB_USER -p$DB_PASSWD"
FILE="/tmp/imported"
if [ ! -f $FILE ]; then
	mysqladmin $MYSQL_CRED drop $DB_NAME --force 2> /dev/null
	mysqladmin $MYSQL_CRED create $DB_NAME --force 2> /dev/null

	for sqlFile in $DUMP_SQL_FOLDER/*
	do
		echo "\n* Importing SQL file $sqlFile ...";
		mysql $MYSQL_CRED $DB_NAME < $sqlFile
	done

	echo "\n* Update shop URL ...";
	mysql $MYSQL_CRED -e "UPDATE \`ps_shop_url\` SET \`domain\`='$PS_DOMAIN', \`domain_ssl\`='$PS_DOMAIN', \`physical_uri\`='/' WHERE \`id_shop_url\`=1;" $DB_NAME
	mysql $MYSQL_CRED -e "UPDATE \`ps_configuration\` SET \`value\`='$PS_DOMAIN' WHERE \`name\`='PS_SHOP_DOMAIN';" $DB_NAME
	mysql $MYSQL_CRED -e "UPDATE \`ps_configuration\` SET \`value\`='$PS_DOMAIN_SSL' WHERE \`name\`='PS_SHOP_DOMAIN';" $DB_NAME

	touch $FILE
fi
bash /tmp/docker_run.sh

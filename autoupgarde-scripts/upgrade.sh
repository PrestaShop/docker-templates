#!/bin/bash

source .env

# Working directories
export RELEASE_DIRECTORY=./releases
export DUMP_DIRECTORY=./dumps
export LOGS_DIRECTORY=./logs

mkdir -p "$RELEASE_DIRECTORY"
mkdir -p "$DUMP_DIRECTORY"
mkdir -p "$LOGS_DIRECTORY"

# Remove previous executions
rm -rf ./logs/*
rm -rf ./releases/*
rm -rf ./dumps/*
docker compose down --volumes --remove-orphans

install() {
  echo "--- Installation of v$1 ---"
  db_version="${1//./}"
  docker compose run -u "$DOCKER_USER_ID" --rm -v ./:/var/www/html/ -w /var/www/html/"$RELEASE_DIRECTORY"/"$1" work-base php install/index_cli.php \
    --step=database --db_server=mysql:3306 --db_name=presta_"$db_version" --db_DOCKER_USER_ID=root --db_password="$MYSQL_ROOT_PASSWORD" --prefix=ps_ --db_clear=1 \
    --domain=localhost:8002 --firstname="Marc" --lastname="Beier" \
    --password=Toto123! --email=demo@prestashop.com --language=fr --country=fr \
    --newsletter=0 --send_email=0 --ssl=0 >"$LOGS_DIRECTORY"/"$1"_install

    if grep -qiE 'fatal|error' "$LOGS_DIRECTORY"/"$1"_install; then
        echo "Docker command failed. See $LOGS_DIRECTORY/$1_install. Stopping the script (v$1)."
        exit 1
    fi

  echo "--- Installation of v$1 done ---"
}

download_release_and_xml() {
  echo "--- Download v$1 Prestashop release and xml MD5 ---"
  docker compose run -u "$DOCKER_USER_ID" --rm -v ./:/var/www/html/ -w /var/www/html/"$RELEASE_DIRECTORY"/"$BASE_VERSION" work-base \
    curl -L https://github.com/PrestaShop/PrestaShop/releases/download/"$1"/prestashop_"$1".zip -o admin/autoupgrade/download/prestashop_"$1".zip
  docker compose run -u "$DOCKER_USER_ID" --rm -v ./:/var/www/html/ -w /var/www/html/"$RELEASE_DIRECTORY"/"$BASE_VERSION" work-base \
    curl -L https://api.prestashop.com/xml/md5/"$1".xml -o admin/autoupgrade/download/prestashop_"$1".xml
   echo "--- Download v$1 Prestashop release and xml MD5 ---"
}

upgrade() {
  echo "--- Upgrade from v$1 to v$2 ---"

  docker compose run -u "$DOCKER_USER_ID" --rm -v ./:/var/www/html/ -w /var/www/html/"$RELEASE_DIRECTORY"/"$BASE_VERSION" work-base /bin/sh -c \
    "cp -r modules/autoupgrade .;
    rm -rf modules/*;
    mv autoupgrade modules/;"

  download_release_and_xml "$2"

  docker compose run -u "$DOCKER_USER_ID" --rm -v ./:/var/www/html/ -w /var/www/html/"$RELEASE_DIRECTORY"/"$BASE_VERSION" work-base \
    sh -c "echo '{\"channel\":\"archive\",\"archive_prestashop\":\"prestashop_$2.zip\",\"archive_num\":\"$2\", \"archive_xml\":\"prestashop_$2.xml\", \"PS_AUTOUP_CHANGE_DEFAULT_THEME\":\"0\", \"skip_backup\": \"1\"}' > modules/autoupgrade/config.json"

  docker compose run -u "$DOCKER_USER_ID" --rm -v ./:/var/www/html/ -w /var/www/html/"$RELEASE_DIRECTORY"/"$BASE_VERSION" work-base \
    php modules/autoupgrade/cli-updateconfig.php --from=modules/autoupgrade/config.json --dir=admin >"$LOGS_DIRECTORY"/"$2"_upgrade

  docker compose run -u "$DOCKER_USER_ID" --rm -v ./:/var/www/html/ -w /var/www/html/"$RELEASE_DIRECTORY"/"$BASE_VERSION" work-base \
    php modules/autoupgrade/tests/testCliProcess.php modules/autoupgrade/cli-upgrade.php --dir="admin" --action="compareReleases" >>"$LOGS_DIRECTORY"/"$2"_upgrade

  docker compose run -u "$DOCKER_USER_ID" --rm -v ./:/var/www/html/ -w /var/www/html/"$RELEASE_DIRECTORY"/"$BASE_VERSION" work-base \
    php modules/autoupgrade/tests/testCliProcess.php modules/autoupgrade/cli-upgrade.php --dir="admin" >>"$LOGS_DIRECTORY"/"$2"_upgrade

  if grep -qiE 'fatal|error' "$LOGS_DIRECTORY"/"$2"_upgrade; then
      echo "Docker command failed. See $LOGS_DIRECTORY/$2_upgrade. Stopping the script."
      exit 1
  fi

  echo "--- Upgrade from v$1 to v$2 done ---"
}

download_release() {
  echo "--- Download v$1 Prestashop release ---"
  docker compose run -u "$DOCKER_USER_ID" --rm -v ./:/var/www/html/ work-base /bin/sh -c \
    "cd $RELEASE_DIRECTORY || exit
     curl -LO https://github.com/PrestaShop/PrestaShop/releases/download/$1/prestashop_$1.zip;
     unzip -o prestashop_$1.zip -d $1 >/dev/null;
     rm prestashop_$1.zip;
     cd $1 || exit;
     unzip -o prestashop.zip >/dev/null;
     rm prestashop.zip;
     mkdir admin/autoupgrade/download;"
  echo "--- Download v$1 Prestashop release done ---"
}

install_module() {
  echo "--- Install autoupgrade module (dev version) --- "
  docker compose run -u "$DOCKER_USER_ID" --rm -v ./:/var/www/html/ -w /var/www/html/"$RELEASE_DIRECTORY"/"$1" composer /bin/sh -c \
    "cd modules;
     git clone $AUTOUPGRADE_GIT_REPO;
     cd autoupgrade;
     git checkout $AUTOUPGRADE_GIT_BRANCH;
     composer install;"
  echo "--- Install autoupgrade module (dev version) done ---"
}

dump_DB() {
  echo "--- Create dump for $1 ---"
  version="${1//./}"
   if [[ -n "$2" ]]; then
      docker compose run --rm mysql sh -c "exec mysqldump -hmysql -uroot --no-data -p$MYSQL_ROOT_PASSWORD presta_$version" >"$DUMP_DIRECTORY"/"$1"_to_"$2"_dump_.sql
   else
      docker compose run --rm mysql sh -c "exec mysqldump -hmysql -uroot --no-data -p$MYSQL_ROOT_PASSWORD presta_$version" >"$DUMP_DIRECTORY"/"$1"_dump_.sql
   fi
  echo "--- Create dump for $1 done ---"
}

create_DB_schema() {
  echo "--- Create database schema for $1 ---"
  version="${1//./}"
  docker compose run --rm mysql mysql -hmysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE presta_$version;"
  echo "--- Create database schema for $1 done ---"
}

create_DB_diff() {
  echo "--- Create database diff between $BASE_VERSION and $1 ---"
  docker compose run -u "$DOCKER_USER_ID" --rm -v ./:/var/www/html/ -w /var/www/html/"$DUMP_DIRECTORY" composer \
     git diff "$BASE_VERSION"_to_"$1"_dump_.sql "$1"_dump_.sql > "$DUMP_DIRECTORY"/diff_"$BASE_VERSION"_upgrated_"$1".txt
  echo "--- Create database diff between $BASE_VERSION and $1 done ---"
}

docker compose up -d mysql
download_release "$BASE_VERSION"
sleep 10
create_DB_schema "$BASE_VERSION"
install "$BASE_VERSION"
install_module "$BASE_VERSION"

if [[ "$RECURSIVE_MODE" == true ]]; then
  previousTag=$BASE_VERSION

  for tag in $(git ls-remote --tags --refs git@github.com:PrestaShop/PrestaShop.git | awk -F/ '{print $NF}'); do
    if dpkg --compare-versions "$tag" gt "$BASE_VERSION" && \
       dpkg --compare-versions "$tag" le "$UPGRADE_VERSION" && \
       [[ "$tag" != *'beta'* && "$tag" != *'rc'* ]]; then

        upgrade "$previousTag" "$tag"
        previousTag=$tag
    fi
  done

else
  upgrade "$BASE_VERSION" "$UPGRADE_VERSION"

  if [[ "$CREATE_AND_COMPARE_DUMP_WITH_FRESH_INSTALL" == true ]]; then
    dump_DB "$BASE_VERSION" "$UPGRADE_VERSION"
    download_release "$UPGRADE_VERSION"
    create_DB_schema "$UPGRADE_VERSION"
    install "$UPGRADE_VERSION"
    dump_DB "$UPGRADE_VERSION"
    create_DB_diff "$UPGRADE_VERSION"
    echo "--- Diff file create, see $DUMP_DIRECTORY/diff_${BASE_VERSION}_upgrated_${UPGRADE_VERSION}.txt ---"
  fi
fi

docker compose up -d prestashop-run
echo "--- Docker container created for upgrade, see result at http://localhost:8002/admin ---"


FRONT_CONTAINER_NAME="visualize-diff-front"
BACK_CONTAINER_NAME="visualize-diff-back"

if ! docker ps -f name=${BACK_CONTAINER_NAME} | grep -q ${BACK_CONTAINER_NAME}; then
    echo "Launching ${BACK_CONTAINER_NAME}"
    docker compose up -d ${BACK_CONTAINER_NAME}
fi

if ! docker ps -f name=${FRONT_CONTAINER_NAME} | grep -q ${FRONT_CONTAINER_NAME}; then
    echo "Launching ${FRONT_CONTAINER_NAME}"
    docker compose up -d ${FRONT_CONTAINER_NAME}
fi

echo "--- If you want to check diff, see diff tool at http://localhost:8080/ ---"

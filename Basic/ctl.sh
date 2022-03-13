#!/usr/bin/env bash
# Author: Hsuan

action=${1-}
target=${2-}
args=("$@")
cur_dir=$(cd $(dirname ${BASH_SOURCE[0]}); pwd )
image_name="hsuan.cloud/hsuan/smartclouds-exercise"
image_tag="0.0.1"

function build() {
  echo -e "\033[42;37mBuild Image: ${image_name}:${image_tag} Start\033[0m"
  docker build -t ${image_name}:${image_tag} ${cur_dir}
  echo -e "\033[42;37mBuild Image: ${image_name}:${image_tag} End\033[0m"
}

function push() {
  echo -e "\033[42;37mPush Image: ${image_name}:${image_tag} Start\033[0m"
  docker push ${image_name}:${image_tag}
  echo -e "\033[42;37mPush Image: ${image_name}:${image_tag} End\033[0m"
}

function start() {
  docker-compose -f ${cur_dir}/docker-compose.yml up -d
  sleep 10
  docker exec -it app bash -c 'cp .env.example .env'
  docker exec -it app bash -c 'php artisan key:generate'
}

function create-mysql-backup() {
  date=$(date +"%Y%m%d%H")
  # echo $date
  database=employees
  db_user=employees
  db_password=employees
  tables_list=$(docker exec -it mysql mysql -u employees -pemployees -e 'show tables from employees;' -s --skip-column-names | awk -F, '$1 !~ /Warning/' | sed -e 's/\r//g')
  if ! -d ${cur_dir}/backup ; then
    mkdir -p ${cur_dir}/backup
  fi
  for TABLE in ${tables_list}; do
    echo -e "\033[42;37m ${TABLE} Backup Start\033[0m"
    docker exec -it mysql mysqldump -u${db_user} -p${db_password} ${database} ${TABLE} | grep -v "Warning" > ${cur_dir}/${TABLE}.sql
    cd ${cur_dir} && tar -zcf "backup/mysql-${date}-${TABLE}.tar.gz" ${TABLE}.sql
    rm ${cur_dir}/${TABLE}.sql
    echo -e "\033[42;37m ${TABLE} Backup End\033[0m"
  done
}

function main() {
  case "${action}" in
  build)
    build
    ;;
  push)
    push
    ;;
  start)
    start
    ;;
  copy-env)
    cp ${cur_dir}/.env.example ${cur_dir}/.env
    ;;
  generate-password)
    RANDOM_PASSWORD=$(date +%s | sha256sum | base64 | head -c 32)
    sed -r -i "s/MYSQL_ROOT_PASSWORD=.*$/MYSQL_ROOT_PASSWORD=${RANDOM_PASSWORD}/g" ${cur_dir}/.env
    echo "MYSQL ROOT PASSWORD: ${RANDOM_PASSWORD}"
    ;;
  create-mysql-backup)
    create-mysql-backup
    ;;
  delete-mysql-backup)
    echo "Delete Backupfiles older than 10 days"
    find ${cur_dir}/backup/ -name "mysql-*.tar.gz" -mtime +10 -delete
    ;;
  cur-dir)
    echo ${cur_dir}
    ;;
  *)
    echo "Please Enter Option"
    ;;
  esac
}

main "$@"

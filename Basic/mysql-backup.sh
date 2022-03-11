#!/bin/bash

action=${1-}
date=$(date +"%Y%m%d%H")
# echo $date
database=employees
db_user=employees
db_password=employees


# echo $list

function backup() {
  tables_list=$(docker exec -it mysql mysql -u employees -pemployees -e 'show tables from employees;' -s --skip-column-names | awk -F, '$1 !~ /Warning/' | sed -e 's/\r//g')
  for TABLE in ${tables_list}; do
    echo -e "\033[42;37m ${TABLE} Backup Start\033[0m"
    docker exec -it mysql mysqldump -u${db_user} -p${db_password} ${database} ${TABLE} | grep -v "Warning" > ${TABLE}.sql
    tar -zcf "backup/mysql-${date}-${TABLE}.tar.gz" ${TABLE}.sql
    rm ${TABLE}.sql
    echo -e "\033[42;37m ${TABLE} Backup End\033[0m"
  done
}

function main() {
  case "${action}" in
  backup)
    backup
    ;;
  crondelete)
    echo "Delete Backupfiles older than 10 days"
    find backup/ -name "mysql-*.tar.gz" -mtime +10 -delete
    ;;
  *)
    echo "Please Enter Option"
    ;;
  esac
}

main "$@"

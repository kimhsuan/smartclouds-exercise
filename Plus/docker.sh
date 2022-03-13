#!/usr/bin/env bash
# Author: Hsuan

image_name="hsuan.cloud/hsuan/smartclouds-exercise-go"
image_tag="20220313"
cur_dir=$(cd $(dirname ${BASH_SOURCE[0]}); pwd )
action=${1-}

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

function run() {
  docker run -d -p 8080:8080 --name go-rest ${image_name}:${image_tag}
}

function main() {
  case "${action}" in
  build)
    build
    ;;
  push)
    push
    ;;
  run)
    run
    ;;
  *)
    echo "Please Enter Option"
    ;;
  esac
}

main "$@"

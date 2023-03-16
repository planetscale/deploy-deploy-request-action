#!/bin/sh -l

command="pscale deploy-request deploy $1 $2 --org $3 -f json"

cmdout=$(eval $command)

if [ "true" == "$4" ];then
  . /.pscale/cli-helper-scripts/wait-for-deploy-request-merged.sh
  wait_for_deploy_request_merged 9 "$1" "$2" "$3" 60
fi